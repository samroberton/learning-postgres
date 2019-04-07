begin;


create table tag (
    tag_name                    text primary key,
    count                       integer not null,
    excerpt_post_id             bigint references post(post_id),
    wiki_post_id                bigint references post(post_id)
);


create function import_tags_file(filename text)
    returns void
as $$
    insert
      into tag ( tag_name,
                 count,
                 excerpt_post_id,
                 wiki_post_id
               )
    select tag_name,
           count,
           excerpt_post_id,
           wiki_post_id
      from xmltable( '/tags/row'
                     passing (select xml (pg_read_file(filename, 0, 1000000000)))
                     columns
                         tag_name text path '@TagName',
                         count integer path '@Count',
                         excerpt_post_id bigint path '@ExcerptPostId',
                         wiki_post_id bigint path '@WikiPostId'
                   );
$$ language sql;


commit;
