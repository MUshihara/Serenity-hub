import ctypes,sys
from pathlib import Path
lua=ctypes.CDLL('liblua5.4.so.0');lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p];lua.luaL_loadbufferx.argtypes=[ctypes.c_void_p,ctypes.c_char_p,ctypes.c_size_t,ctypes.c_char_p,ctypes.c_char_p];lua.lua_pcallk.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong,ctypes.c_void_p];lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p];lua.lua_tolstring.restype=ctypes.c_char_p
L=lua.luaL_newstate();lua.luaL_openlibs(L)
p=Path(sys.argv[1]);b=p.read_bytes();r=lua.luaL_loadbufferx(L,b,len(b),str(p).encode(),None)
if not r and '--syntax' not in sys.argv:r=lua.lua_pcallk(L,0,0,0,0,None)
if r:raise RuntimeError(lua.lua_tolstring(L,-1,None).decode())
