For %%F In ( x:\Digitales-Backup\Biblisches\Vortr�ge\Hydroplate\Images\* )  do @(
  if not exist "%%~nxF" @(
    echo copying %%F
    @copy %%F . > nul
  ) else @( 
    @rem echo exists: %%F
  )
)
