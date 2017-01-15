" Diamond highlighting fix.
" http://stackoverflow.com/questions/31736986/how-do-i-make-vim-aware-of-the-java-8-lambda-syntax
syn clear javaError
syn match javaError "<<<\|\.\.\|=>\|||=\|&&=\|\*\/"
syn match javaFuncDef "[^-]->"
