For %%F In ( %digitales_backup%Biblisches\Vorträge\Hydroplate\Images\* )  do @(
  if not exist "%%~nxF" @(
    echo copying %%F
    @copy %%F . > nul
  ) else @( 
    @rem echo exists: %%F
  )
)
