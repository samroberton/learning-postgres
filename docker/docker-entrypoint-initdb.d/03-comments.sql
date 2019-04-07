begin;


create table comment (
    comment_id                  bigint primary key,
    post_id                     bigint not null references post(post_id),
    score                       integer not null,
    text                        text not null,
    creation_date               timestamptz not null,
    se_user_id                  bigint references se_user(se_user_id)
);


create function import_comments_file(filename text)
    returns void
as $$
    insert
      into comment ( comment_id,
                     post_id,
                     score,
                     text,
                     creation_date,
                     se_user_id
                   )
    select comment_id,
           post_id,
           score,
           text,
           creation_date,
           se_user_id
      from xmltable( '/comments/row'
                     passing (select xml (pg_read_file(filename, 0, 1000000000)))
                     columns
                         comment_id bigint path '@Id',
                         post_id bigint path '@PostId',
                         score integer path '@Score',
                         text text path '@Text',
                         creation_date timestamptz path '@CreationDate',
                         se_user_id bigint path '@UserId'
                   );
$$ language sql;


commit;
