function video-to-gif
    # derived from https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
    ffmpeg -i $argv[1] \
           -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" \
           -f gif \
           $argv[2]
end
