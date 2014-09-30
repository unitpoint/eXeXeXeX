cd tools
call update-assets.cmd
cd ..

python ..\..\oxygine-framework\tools\process_xml2.py -x xmls/sounds.xml --src_data data --dest_data data
python ..\..\oxygine-framework\tools\process_xml2.py -x xmls/game.xml --src_data data --dest_data data
