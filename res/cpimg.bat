For %%F In ( %digitales_backup%Biblisches\Vortr�ge\Hydroplate\Images\* )  do @(
  if not exist "%%~nxF" @(
    echo copying %%F
    @copy %%F . > nul
  ) else @( 
    @rem echo exists: %%F
  )
)
