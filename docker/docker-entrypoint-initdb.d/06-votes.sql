begin;


create type vote_type as enum (
    'AcceptedByOriginator',
    'UpMod',
    'DownMod',
    'Offensive',
    'Favorite',
    'Close',
    'Reopen',
    'BountyStart',
    'BountyClose',
    'Deletion',
    'Undeletion',
    'Spam',
    'ModeratorReview',
    'ApproveEditSuggestion'
);


create table vote (
    vote_id                     bigint primary key,
    post_id                     bigint not null references post(post_id),
    vote_type                   vote_type not null,
    se_user_id                  bigint references se_user(se_user_id),
    creation_date               timestamptz not null,
    bounty_amount               integer
);


create function import_votes_file(filename text)
    returns void
as $$
    insert
      into vote ( vote_id,
                  post_id,
                  vote_type,
                  se_user_id,
                  creation_date,
                  bounty_amount
                )
    select xml.vote_id,
           xml.post_id,
           case xml.vote_type_id
             when  1 then 'AcceptedByOriginator' :: vote_type
             when  2 then 'UpMod'
             when  3 then 'DownMod'
             when  4 then 'Offensive'
             when  5 then 'Favorite'
             when  6 then 'Close'
             when  7 then 'Reopen'
             when  8 then 'BountyStart'
             when  9 then 'BountyClose'
             when 10 then 'Deletion'
             when 11 then 'Undeletion'
             when 12 then 'Spam'
             when 15 then 'ModeratorReview'
             when 16 then 'ApproveEditSuggestion'
           end,
           xml.se_user_id,
           xml.creation_date,
           xml.bounty_amount
      from xmltable( '/votes/row'
                     passing (select xml (pg_read_file(filename, 0, 1000000000)))
                     columns
                         vote_id bigint path '@Id',
                         post_id bigint path '@PostId',
                         vote_type_id integer path '@VoteTypeId',
                         se_user_id bigint path '@UserId',
                         creation_date timestamptz path '@CreationDate',
                         bounty_amount integer path '@BountyAmount'
                   ) xml
           join post using (post_id) ;
$$ language sql;


commit;
