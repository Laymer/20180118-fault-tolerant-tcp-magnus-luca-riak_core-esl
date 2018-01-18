-module(raw_tcp_app_tests).
-include_lib("eunit/include/eunit.hrl").
-include_lib("pkt/include/pkt.hrl").

dummy_test() ->
    ?assert(true).

open_raw_socket_test() ->
    SAddr = {127,0,0,1},
    Self = self(),
    spawn_link(fun() -> tcp_server(Self, SAddr) end),
    LPort = receive {port, P} -> P end,
    ?debugFmt("LPort ~p", [LPort]),
    CIf = "tun0",
    {ok, CRef} = tuncer:create(CIf, [tun, no_pi, {active, true}]),
    CAddr = SAddr,
    ok = tuncer:up(CRef, CAddr),
    %% spawn_link(fun() -> tcpdump(CIf) end),
    ?debugFmt("CRef ~p", [CRef]),
    timer:sleep(2000),
    %% https://github.com/msantos/pkt/blob/3afb1967f34324c1dec5035a6e36232da815c2e6/test/pkt_ipv4_tests.erl#L117
    CPort = 65000, %% XXX
    CSynTcp = pkt:tcp(#tcp{sport = CPort,
                           dport = LPort,
                           seqno = 0, %% XXX
                           syn = 1}),
    CSynIp = pkt:ipv4(#ipv4{len = byte_size(CSynTcp),
                            saddr = CAddr,
                            daddr = SAddr}),
    ok = tuncer:send(CRef, <<CSynIp/binary, CSynTcp/binary>>),
    ?debugHere,
    receive
        {tuntap_error, CRef, E} ->
            ?debugFmt("Unexpected tuntap error ~p", [E]);
        {tuntap, CRef, Buf} ->
            ?debugFmt("Got ~p", [pkt:decode(ipv4, Buf)]),
            ok;
        M ->
            ?debugFmt("Unexpected msg ~p", [M])
    end,
    ok.

tcp_server(Parent, Addr) ->
    {ok, LSock} = gen_tcp:listen(0, [binary, {packet, 0}, {active, false}, {ip, Addr}]),
    {ok, LPort} = inet:port(LSock),
    Parent ! {port, LPort},
    {ok, SSock} = gen_tcp:accept(LSock),
    ?debugFmt("Peer of server: ~p", [inet:peername(SSock)]),
    ok = gen_tcp:close(SSock),
    ok = gen_tcp:close(LSock),
    timer:sleep(5000).

tcpdump(If) ->
    ?debugVal(os:cmd("tcpdump --list-interfaces")),
    ?debugVal(os:cmd("sudo tcpdump -l -vvv -c 1 -i " ++ If ++ " | tee /vagrant/tcpdump.log")),
    ?debugMsg("tcpdump out printed").
