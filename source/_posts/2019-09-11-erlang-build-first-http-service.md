---
layout: post
title:  使用 erlang 构建一个 http 服务
date:   2019-09-11 17:55:18 +0800
tags: [erlang, http]
---


## 输出 hello world

- $(RELX_REL_NAME)  计算一直错误问题

```makefile
...
...

define get_relx_release.erl
	{ok, Config} = file:consult("$(call core_native_path,$(RELX_CONFIG))"),
	{release, {Name, Vsn0}, _} = lists:keyfind(release, 1, Config),
	Vsn = case Vsn0 of
		{cmd, Cmd} -> os:cmd(Cmd);
		semver -> "";
		{semver, _} -> "";
		VsnStr -> Vsn0
	end,
	Extended = case lists:keyfind(extended_start_script, 1, Config) of
		{_, true} -> "1";
		_ -> ""
	end,
	io:format("~s ~s ~s", [Name, Vsn, Extended]),
	halt(0).
endef

RELX_REL := $(shell $(call erlang,$(get_relx_release.erl)))
RELX_REL_NAME := $(word 1,$(RELX_REL))
RELX_REL_VSN := $(word 2,$(RELX_REL))
RELX_REL_CMD := $(if $(word 3,$(RELX_REL)),console)

ifeq ($(PLATFORM),msys2)
RELX_REL_EXT := .cmd
endif

run:: all
	$(verbose) $(RELX_OUTPUT_DIR)/$(RELX_REL_NAME)/bin/$(RELX_REL_NAME)$(RELX_REL_EXT) $(RELX_REL_CMD)
....
...


```

```erlang
%% ~/.erlang
Home = os:getenv("HOME"),


io:format("~p~n", [Home]),

Dir = Home ++ "/nobackups/erlang_imports/_build/default/lib/".

io:format("~p~n", [Dir]).

case file:list_dir(Dir) of
    {ok, L} ->
	io:format("~p~n", [L]),
	lists:foreach(fun(I) -> 
			     Path = Dir ++ "/" ++ I ++ "/ebin",
			     io:format("add path: ~p~n", [Path]),
			     code:add_path(Path)
		     end, L);
    {error, X} ->
	      io:format("~p~n", [X])
end.


```

- https://ninenines.eu/docs/en/cowboy/2.6/guide/getting_started/
- https://erlang.mk/guide/getting_started.html
