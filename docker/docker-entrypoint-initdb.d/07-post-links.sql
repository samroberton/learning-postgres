begin;


create type post_link_type as enum ('Linked', 'Duplicate');


create table post_link (
    post_link_id                bigint primary key,
    creation_date               timestamptz not null,
    post_id                     bigint not null references post(post_id),
    related_post_id             bigint not null references post(post_id),
    link_type                   post_link_type not null
);


create function import_post_links_file(filename text)
    returns void
as $$
    insert
      into post_link ( post_link_id,
                       creation_date,
                       post_id,
                       related_post_id,
                       link_type
                     )
    select xml.post_link_id,
           xml.creation_date,
           xml.post_id,
           xml.related_post_id,
           case
             when xml.link_type_id = 1 then 'Linked' :: post_link_type
             when xml.link_type_id = 3 then 'Duplicate'
           end
      from xmltable( '/postlinks/row'
                     passing (select xml (pg_read_file(filename, 0, 1000000000)))
                     columns
                         post_link_id bigint path '@Id',
                         creation_date timestamptz path '@CreationDate',
                         post_id bigint path '@PostId',
                         related_post_id bigint path '@RelatedPostId',
                         link_type_id integer path '@LinkTypeId'
                   ) xml
           join post p1 on p1.post_id = xml.post_id
           join post p2 on p2.post_id = xml.related_post_id;
$$ language sql;


commit;
