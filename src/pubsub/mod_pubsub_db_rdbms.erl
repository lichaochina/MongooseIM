%%%----------------------------------------------------------------------
%%% File    : mod_pubsub_db_rdbms.erl
%%% Author  : Piotr Nosek <piotr.nosek@erlang-solutions.com>
%%% Purpose : PubSub RDBMS backend
%%% Created : 2 Nov 2018 by Piotr Nosek <piotr.nosek@erlang-solutions.com>
%%%----------------------------------------------------------------------

-module(mod_pubsub_db_rdbms).
-author('piotr.nosek@erlang-solutions.com').

-include("pubsub.hrl").
-include("jlib.hrl").

-export([start/0, stop/0]).
% Funs execution
-export([transaction/2, dirty/2]).
% Direct #pubsub_state access
-export([del_state/2, get_state/2,
         get_states/1, get_states_by_lus/1, get_states_by_bare/1,
         get_states_by_bare_and_full/1, get_own_nodes_states/1]).
% Affiliations
-export([
         set_affiliation/3,
         get_affiliation/2
        ]).
% Subscriptions
-export([
         add_subscription/4,
         get_node_subscriptions/1,
         get_node_entity_subscriptions/2,
         delete_subscription/3,
         delete_all_subscriptions/2,
         update_subscription/4
        ]).
% Items
-export([
         add_item/3,
         remove_items/3,
         remove_all_items/1
        ]).

%%====================================================================
%% Behaviour callbacks
%%====================================================================

%% ------------------------ Backend start/stop ------------------------

-spec start() -> ok.
start() ->
    mod_pubsub_db_mnesia:start().

-spec stop() -> ok.
stop() ->
    mod_pubsub_db_mnesia:stop().

%% ------------------------ Fun execution ------------------------

%% TODO: Replace these with RDBMS counterparts when this backend supports all
%% PubSub operations!

transaction(Fun, ErrorDebug) ->
    mod_pubsub_db_mnesia:transaction(Fun, ErrorDebug).

dirty(Fun, ErrorDebug) ->
    mod_pubsub_db_mnesia:dirty(Fun, ErrorDebug).

%% ------------------------ Direct #pubsub_state access ------------------------

-spec get_state(Nidx :: mod_pubsub:nodeIdx(),
                JID :: jid:jid()) ->
    {ok, mod_pubsub:pubsubState()}.
get_state(Nidx, JID) ->
    mod_pubsub_db_mnesia:get_state(Nidx, JID).

-spec get_states(Nidx :: mod_pubsub:nodeIdx()) ->
    {ok, [mod_pubsub:pubsubState()]}.
get_states(Nidx) ->
    mod_pubsub_db_mnesia:get_states(Nidx).

-spec get_states_by_lus(JID :: jid:jid()) ->
    {ok, [mod_pubsub:pubsubState()]}.
get_states_by_lus(JID) ->
    mod_pubsub_db_mnesia:get_states_by_lus(JID).

-spec get_states_by_bare(JID :: jid:jid()) ->
    {ok, [mod_pubsub:pubsubState()]}.
get_states_by_bare(JID) ->
    mod_pubsub_db_mnesia:get_states_by_bare(JID).

-spec get_states_by_bare_and_full(JID :: jid:jid()) ->
    {ok, [mod_pubsub:pubsubState()]}.
get_states_by_bare_and_full(JID) ->
    mod_pubsub_db_mnesia:get_states_by_bare_and_full(JID).

-spec get_own_nodes_states(JID :: jid:jid()) ->
    {ok, [mod_pubsub:pubsubState()]}.
get_own_nodes_states(JID) ->
    mod_pubsub_db_mnesia:get_own_nodes_states(JID).

-spec del_state(Nidx :: mod_pubsub:nodeIdx(),
                LJID :: jid:ljid()) -> ok.
del_state(Nidx, LJID) ->
    mod_pubsub_db_mnesia:del_state(Nidx, LJID).

% ------------------- Affiliations --------------------------------

-spec set_affiliation(Nidx :: mod_pubsub:nodeIdx(),
                      JID :: jid:jid(),
                      Affiliation :: mod_pubsub:affiliation()) -> ok.
set_affiliation(Nidx, JID, Affiliation) ->
    mod_pubsub_db_mnesia:set_affiliation(Nidx, JID, Affiliation).

-spec get_affiliation(Nidx :: mod_pubsub:nodeIdx(),
                      JID :: jid:jid()) ->
    {ok, mod_pubsub:affiliation()}.
get_affiliation(Nidx, JID) ->
    mod_pubsub_db_mnesia:get_affiliation(Nidx, JID).

% ------------------- Subscriptions --------------------------------

-spec add_subscription(Nidx :: mod_pubsub:nodeIdx(),
                       JID :: jid:jid(),
                       Sub :: mod_pubsub:subscription(),
                       SubId :: mod_pubsub:subId()) -> ok.
add_subscription(Nidx, JID, Sub, SubId) ->
    mod_pubsub_db_mnesia:add_subscription(Nidx, JID, Sub, SubId).

-spec get_node_subscriptions(Nidx :: mod_pubsub:nodeIdx()) ->
    {ok, [{Entity :: jid:jid(), Sub :: mod_pubsub:subscription(), SubId :: mod_pubsub:subId()}]}.
get_node_subscriptions(Nidx) ->
    mod_pubsub_db_mnesia:get_node_subscriptions(Nidx).

-spec get_node_entity_subscriptions(Nidx :: mod_pubsub:nodeIdx(),
                                    JID :: jid:jid()) ->
    {ok, [{Sub :: mod_pubsub:subscription(), SubId :: mod_pubsub:subId()}]}.
get_node_entity_subscriptions(Nidx, JID) ->
    mod_pubsub_db_mnesia:get_node_entity_subscriptions(Nidx, JID).

-spec delete_subscription(
        Nidx :: mod_pubsub:nodeIdx(),
        JID :: jid:jid(),
        SubId :: mod_pubsub:subId()) ->
    ok.
delete_subscription(Nidx, JID, SubId) ->
    mod_pubsub_db_mnesia:delete_subscription(Nidx, JID, SubId).

-spec delete_all_subscriptions(
        Nidx :: mod_pubsub:nodeIdx(),
        JID :: jid:jid()) ->
    ok.
delete_all_subscriptions(Nidx, JID) ->
    mod_pubsub_db_mnesia:delete_all_subscriptions(Nidx, JID).

-spec update_subscription(Nidx :: mod_pubsub:nodeIdx(),
                          JID :: jid:jid(),
                          Subscription :: mod_pubsub:subscription(),
                          SubId :: mod_pubsub:subId()) ->
    ok.
update_subscription(Nidx, JID, Subscription, SubId) ->
    mod_pubsub_db_mnesia:update_subscription(Nidx, JID, Subscription, SubId).

% ------------------- Items --------------------------------

-spec add_item(Nidx :: mod_pubsub:nodeIdx(),
               JID :: jid:jid(),
               ItemId :: mod_pubsub:itemId()) ->
    ok.
add_item(Nidx, JID, ItemId) ->
    mod_pubsub_db_mnesia:add_item(Nidx, JID, ItemId).

-spec remove_items(Nidx :: mod_pubsub:nodeIdx(),
                   JID :: jid:jid(),
                   ItemIds :: [mod_pubsub:itemId()]) ->
    ok.
remove_items(Nidx, JID, ItemIds) ->
    mod_pubsub_db_mnesia:remove_items(Nidx, JID, ItemIds).

-spec remove_all_items(Nidx :: mod_pubsub:nodeIdx()) ->
    ok.
remove_all_items(Nidx) ->
    mod_pubsub_db_mnesia:remove_all_items(Nidx).

