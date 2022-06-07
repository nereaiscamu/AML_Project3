function bursts_dur = compute_duration(onsets, offsets, SR)
    bursts_dur = [];
    if offsets(1)<onsets(1)
        offsets = offsets(2:end);
    end
    max_length = min(length(onsets), length(offsets));
    for i=1:max_length
        if offsets(i)-onsets(i) > 0 
            bursts_dur = [bursts_dur; (offsets(i)-onsets(i))/SR];
        end
    end

end
