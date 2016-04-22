function wav = normalize(inWav)

mn = min(inWav);
mx = max(inWav);
chFactor = 1/(mx-mn);
wav = (inWav-mn)*chFactor;