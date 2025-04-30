
















def bin_for_freq(freq):
    return int(
            round(
                (float(fft_length)/float(sample_rate)) * freq
                )
            )

def freq_for_bin(n):
    return n * (sample_rate/float(fft_length))

def freq_bounds_for_bin(n):
    width = sample_rate/float(fft_length)
    central = freq_for_bin(n);
    return (central - width/2, central + width/2)
