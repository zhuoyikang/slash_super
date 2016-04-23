-module(slash_super).
-compile([export_all]).

-include("def.hrl").

%% 查找某一个Node上任意一个super.
get(Node) ->
    List = mnesia:dirty_read(super, Node),
    PidList = [Pid || #super{pid=Pid} <- List],
    lists:nth(random:uniform(length(PidList)), PidList).

%% 同步启动，等待结果.
start_sync(Node, Spec) ->
    Pid = slash_super:get(Node),
    gen_server:call(Pid, {start_child, Spec}).

%% 异步启动，传入回调函数.
start_async(Node, Spec, Fun) ->
    Pid = slash_super:get(Node),
    gen_server:cast(Pid, {start_child, Spec, Fun}).


