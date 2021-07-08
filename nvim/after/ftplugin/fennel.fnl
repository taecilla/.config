(fn compile-all []
  (let [
    call vim.fn
    compile (require :aniseed.compile)
    files (call.glob "**/*.fnl" false true)]
    (each [_ fennel-path (ipairs files)]
      (local lua-path (.. (call.fnamemodify fennel-path ":r") ".lua"))
      (compile.file fennel-path lua-path))))

(set My.compile_all_fennel compile-all)
(vim.cmd "command! AniseedCompileAll call v:lua.My.compile_all_fennel()")
