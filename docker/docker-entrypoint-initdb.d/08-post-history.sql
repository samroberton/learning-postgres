begin;


create table post_history (
    post_history_id             bigint primary key,
    post_history_type_id        integer not null,
    post_id                     bigint not null references post(post_id),
    revision_guid               uuid not null,
    creation_date               timestamptz not null,
    se_user_id                  bigint not null references se_user(se_user_id),
    text                        text not null
);


create function import_post_history_file(filename text)
    returns void
as $$
    insert
      into post_history ( post_history_id,
                          post_history_type_id,
                          post_id,
                          revision_guid,
                          creation_date,
                          se_user_id,
                          text
                        )
    select post_history_id,
           post_history_type_id,
           post_id,
           revision_guid,
           creation_date,
           se_user_id,
           text
      from xmltable( '/posthistory/row'
                     passing (select xml (pg_read_file(filename, 0, 1000000000)))
                     columns
                         post_history_id bigint path '@Id',
                         post_history_type_id integer path '@PostHistoryTypeId',
                         post_id bigint path '@PostId',
                         revision_guid uuid path '@RevisionGuid',
                         creation_date timestamptz path '@CreationDate',
                         se_user_id bigint path '@UserId',
                         text text path '@Text'
                   ) x
     where x.revision_guid is not null;
$$ language sql;


commit;
