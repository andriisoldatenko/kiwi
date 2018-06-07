if redis.call("EXISTS", 'parking_spots') == 0 then
    for i=1,99 do
        redis.call('RPUSH', 'parking_spots', i)
    end
end

local aircraft_id = tonumber(KEYS[1])
local parking_spot_id

if aircraft_id > 80 or aircraft_id < 1 then
    return 'Please select aircarft_id between 1..80'
end

if redis.call('HEXISTS', 'aircaft:parking_spots', aircraft_id) == 0 then
    parking_spot_id = redis.call('LPOP', 'parking_spots')
    redis.call("HSET", 'aircaft:parking_spots', aircraft_id, parking_spot_id)
else
    parking_spot_id = redis.call("HGET", 'aircaft:parking_spots', aircraft_id)
end

return parking_spot_id
