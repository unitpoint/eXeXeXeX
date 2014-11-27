cd tools
call update-assets.cmd
cd ..

rem python ..\..\oxygine-framework\tools\oxyresbuild.py -x xmls/sounds.xml --src_data data --dest_data data
python ..\..\oxygine-framework\tools\oxyresbuild.py -x xmls/game.xml --src_data data --dest_data data
python ..\..\oxygine-framework\tools\oxyresbuild.py -x xmls/logo.xml --src_data data --dest_data data
