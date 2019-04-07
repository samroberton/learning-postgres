begin;


create type post_type as enum (
    'Question',
    'Answer',
    'Orphaned tag wiki',
    'Tag wiki excerpt',
    'Tag wiki',
    'Moderator nomination',
    'Wiki placeholder',
    'Privilege wiki'
);


create table post (
    post_id                     bigint primary key,
    -- `parent_post_id` foreign key constraint is added later in a separate
    -- step, once the table is populated.
    parent_post_id              bigint,
    post_type                   post_type not null,
    creation_date               timestamptz not null,
    score                       integer not null,
    view_count                  bigint,
    body                        text not null,
    owner_se_user_id            bigint references se_user(se_user_id),
    last_editor_se_user_id      bigint references se_user(se_user_id),
    last_edit_date              timestamptz,
    last_activity_date          timestamptz not null,
    title                       text,
    tags                        text[],
    answer_count                integer,
    comment_count               integer not null,
    favorite_count              integer,
    closed_date                 timestamptz,
    community_owned_date        timestamptz
);


create function import_posts_file(filename text)
    returns void
as $$
    insert
      into post ( post_id,
                  parent_post_id,
                  post_type,
                  creation_date,
                  score,
                  view_count,
                  body,
                  owner_se_user_id,
                  last_editor_se_user_id,
                  last_edit_date,
                  last_activity_date,
                  title,
                  tags,
                  answer_count,
                  comment_count,
                  favorite_count,
                  closed_date,
                  community_owned_date
                )
      select post_id,
             parent_post_id,
             case post_type_id
               when 1 then 'Question' :: post_type
               when 2 then 'Answer'
               when 3 then 'Orphaned tag wiki'
               when 4 then 'Tag wiki excerpt'
               when 5 then 'Tag wiki'
               when 6 then 'Moderator nomination'
               when 7 then 'Wiki placeholder'
               when 8 then 'Privilege wiki'
             end,
             creation_date,
             score,
             view_count,
             body,
             owner_se_user_id,
             last_editor_se_user_id,
             last_edit_date,
             last_activity_date,
             title,
             (select array_agg(t.tag) from (select re_match[1] as tag from regexp_matches(tags, '<(.*?)>', 'g') re_match) t),
             answer_count,
             comment_count,
             favorite_count,
             closed_date,
             community_owned_date
        from xmltable( '/posts/row'
                       passing (select xml (pg_read_file(filename, 0, 1000000000)))
                       columns
                           post_id bigint path '@Id',
                           parent_post_id bigint path '@ParentId',
                           post_type_id integer path '@PostTypeId',
                           creation_date timestamptz path '@CreationDate',
                           score integer path '@Score',
                           view_count bigint path '@ViewCount',
                           body text path '@Body',
                           owner_se_user_id bigint path '@OwnerUserId',
                           last_editor_se_user_id bigint path '@LastEditorUserId',
                           last_edit_date timestamptz path '@LastEditDate',
                           last_activity_date timestamptz path '@LastActivityDate',
                           title text path '@Title',
                           tags text path '@Tags',
                           answer_count integer path '@AnswerCount',
                           comment_count integer path '@CommentCount',
                           favorite_count integer path '@FavoriteCount',
                           closed_date timestamptz path '@ClosedDate',
                           community_owned_date timestamptz path '@CommunityOwnedDate'
                     );
$$ language sql;


commit;
