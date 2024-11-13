%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%%
%%% -------------------------------------------------------------------
-module(all).       
 
-export([start/0]).



-define(Appl,zigbee_server).
-define(TestAppl,test_zigbee_server).

%%---------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
   
    ok=setup(),
    timer:sleep(2*5000),
    ok=test1(),
    io:format("Test OK !!! ~p~n",[?MODULE]),
    timer:sleep(2000),
 %   init:stop(),
    ok.
%%-----------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test1()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    AllInfo=zigbee_server:get_all(),
    io:format("AllInfo ~p~n",[{AllInfo,?MODULE,?FUNCTION_NAME,?LINE}]),

ok.
%%-----------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
  
    ok=application:start(test_appl),
    pong=log:ping(),
    pong=rd:ping(),
    %% To be changed when create a new server
    pong=?Appl:ping(),

    

    ok.
