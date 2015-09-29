let s:plugin_path = expand("<sfile>:p:h:h")
let s:default_command = "ginkgo {spec}"
let s:force_gui = 0

if !exists("g:ginkgo_runner")
  let g:ginkgo_runner = "os_x_terminal"
endif

function! RunAllGinkgo()
  let s:last_spec = "./..."
  call s:RunSpecs(s:last_spec)
endfunction

function! RunCurrentGinkgoFile()
  if s:InSpecFile()
    let s:last_spec_file = s:CurrentFilePath()
    let s:last_spec = s:last_spec_file
    call s:RunSpecs(s:last_spec_file)
  elseif exists("s:last_spec_file")
    call s:RunSpecs(s:last_spec_file)
  endif
endfunction

function! RunNearestGinkgo()
  if s:InSpecFile()
    let test = s:TestFunc()

    let s:last_spec_file = s:CurrentFilePath()
    let s:last_spec_file_with_line = test . " " . s:last_spec_file
    let s:last_spec = s:last_spec_file_with_line
    call s:RunSpecs(s:last_spec_file_with_line)
  elseif exists("s:last_spec_file_with_line")
    call s:RunSpecs(s:last_spec_file_with_line)
  endif
endfunction

function! RunLastGinkgo()
  if exists("s:last_spec")
    call s:RunSpecs(s:last_spec)
  endif
endfunction

" === local functions ===

function! s:TestFunc()
  " search flags legend (used only)
  " 'b' search backward instead of forward
  " 'c' accept a match at the cursor position
  " 'n' do Not move the cursor
  " 'W' don't wrap around the end of the file
  "
  " for the full list
  " :help search
  let test = search('It(', "bcnW")

  if test == 0
      echo "vim-gotest: [test] no test found immediate to cursor"
      return 0
  end

  let line = getline(test)
  let name = substitute(line, '\(\s*It("\)\(.*\)\(",.*\)', '\2', "g")

  return "-focus \"" . name . "$\""
endfunction

function! s:RunSpecs(spec_location)
  let s:rspec_command = substitute(s:GinkgoCommand(), "{spec}", a:spec_location, "g")

  execute s:rspec_command
endfunction

function! s:InSpecFile()
  return match(expand("%"), "_test.go$") != -1
endfunction

function! s:GinkgoCommand()
  if s:GinkgoCommandProvided() && s:IsMacGui()
    let l:command = s:GuiCommand(g:ginkgo_command)
  elseif s:GinkgoCommandProvided()
    let l:command = g:ginkgo_command
  elseif s:IsMacGui()
    let l:command = s:GuiCommand(s:default_command)
  else
    let l:command = s:DefaultTerminalCommand()
  endif

  return l:command
endfunction

function! s:GinkgoCommandProvided()
  return exists("g:ginkgo_command")
endfunction

function! s:DefaultTerminalCommand()
  return "!" . s:ClearCommand() . " && echo " . s:default_command . " && " . s:default_command
endfunction

function! s:CurrentFilePath()
  return "./" . expand('%:h')
endfunction

function! s:GuiCommand(command)
  return "silent ! '" . s:plugin_path . "/bin/" . g:gospec_runner . "' '" . a:command . "'"
endfunction

function! s:ClearCommand()
  if s:IsWindows()
    return "cls"
  else
    return "clear"
  endif
endfunction

function! s:IsMacGui()
  return s:force_gui || (has("gui_running") && has("gui_macvim"))
endfunction

function! s:IsWindows()
  return has("win32") && fnamemodify(&shell, ':t') ==? "cmd.exe"
endfunction

" begin vspec config
function! ginkgorunner#scope()
  return s:
endfunction

function! ginkgorunner#sid()
    return maparg('<SID>', 'n')
endfunction
nnoremap <SID> <SID>
" end vspec config
