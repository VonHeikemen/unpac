if exists('g:loaded_unpac')
  finish
endif

let g:loaded_unpac = 1

let s:minpac_init = 0

function! unpac#init(...) abort
  let s:minpac_opts = get(a:000, 0, {})

  if exists('#UnPac')
    augroup UnPac
      autocmd!
    augroup END
    augroup! UnPac
  endif

  let s:repos = {}
endfunction

function! unpac#add(repo, ...) abort
  let l:opts = get(a:000, 0, {})

  if has_key(l:opts, 'name')
    let l:plug_name = l:opts.name
  else
    let l:plug_name = substitute(a:repo, '^.*/', '', '')
  endif

  if has_key(l:opts, 'for')
    let l:opts['type'] = 'opt'
    let l:ft = type(l:opts.for) == type([]) ? join(l:opts.for, ',') : l:opts.for

    augroup UnPac
      execute printf('autocmd FileType %s packadd %s', l:ft, l:plug_name)
    augroup END
  endif

  if has_key(l:opts, 'command')
    let l:opts['type'] = 'opt'
    let l:commands = type(l:opts.command) == type([]) ? l:opts.command : [l:opts.command]

    for l:cmd in l:commands
      execute printf("command! -nargs=* -range -bang %s packadd %s | call s:do_cmd('%s', \"<bang>\", <line1>, <line2>, <q-args>)", l:cmd, l:plug_name, l:cmd)
    endfor
  endif

  if has_key(l:opts, 'event')
    let l:opts['type'] = 'opt'
    let l:events = type(l:opts.event) == type([]) ? l:opts.event : [l:opts.event]

    for l:event in l:events
      let l:evt_arr = split(l:event)

      if len(l:evt_arr) > 1
        let l:event_name = l:evt_arr[0]
        let l:event_pattern = l:evt_arr[1]
      else
        let l:event_name = l:event
        let l:event_pattern = '*'
      endif

      augroup UnPac
        execute printf('autocmd %s %s :packadd %s', l:event_name, l:event_pattern, l:plug_name)
      augroup END
    endfor
  endif

  if get(l:opts, 'type', 'init') == 'init'
    let l:opts['type'] = 'opt'
    try
      execute printf('packadd %s', l:plug_name)
    catch
      echom printf('%s is not installed', l:plug_name)
    endtry
  endif

  if has_key(l:opts, 'do')
    let l:opts['do'] = function('s:update_hook', [l:opts['do']])
  endif

  let s:repos[a:repo] = l:opts
endfunction

function! unpac#update(...) abort
  call s:begin()
  call call(function('minpac#update'), a:000)
endfunction

function! unpac#clean(...) abort
  call s:begin()
  call call(function('minpac#clean'), a:000)
endfunction

function! unpac#status() abort
  call s:begin()
  call minpac#status()
endfunction

function! s:begin() abort
  packadd minpac

  call minpac#init(s:minpac_opts)
  for [repo, opts] in items(s:repos)
    call minpac#add(repo, opts)
  endfor
endfunction

function! s:do_cmd(cmd, bang, start, end, args)
  exec printf('%s%s%s %s', (a:start == a:end ? '' : (a:start.','.a:end)), a:cmd, a:bang, a:args)
endfunction

function! s:update_hook(hook, hooktype, name) abort
  execute printf('packadd %s', a:name)
  try
    if type(a:hook) == v:t_func
      call call(a:hook, [a:hooktype, a:name])
    elseif type(a:hook) == v:t_string
      execute a:hook
    endif
  catch
    echom printf('error in %s hook of %s', a:hooktype, a:name)
  endtry
endfunction

command! -bar -nargs=+ Pack call unpac#add(<args>)

command! -nargs=* PackUpdate call s:begin() | call minpac#update(<args>)
command! -nargs=* PackClean  call s:begin() | call minpac#clean(<args>)
command! PackStatus call s:begin() | call minpac#status()

