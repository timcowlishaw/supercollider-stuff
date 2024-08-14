def bin_for_freq(freq):
    return int(
            round(
                (float(fft_length)/float(sample_rate)) * freq
                )
            )

def freq_for_bin(freq):
    return n * (sample_rate/float(fft_length))
