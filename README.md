# ExTram

# Start process
ExTram.start_link()

# Move the tram to the first stop
ExTram.trigger(:start) 

# Move the tram to the nextstop
ExTram.trigger(:close_doors)
ExTram.trigger(:stop_sign)
ExTram.trigger(:open_doors)

# Stop moving
Tram.trigger(:finish)
