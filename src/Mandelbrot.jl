module Mandelbrot
export mandelbrot_image, mandelbrot, scale, minmax_scale

using Base.Threads, Distributed

function mandelbrot(c::Complex, max_iter::Int)
    z = 0.0 + 0.0im
    for i in 1:max_iter
        z = z^2 + c
        if abs(z) > 2
            return max_iter - i
        end
    end
    return 0
end

function mandelbrot_image(width, height, max_iter = 1000; rmin = -2, rmax = 1, imin = -1, imax = 1)
    @time A = [
        Complex((j/width * (rmax - rmin) + rmin), (i/height * (imax - imin) + imin))
        for i in 1:height, j in 1:width
    ]

    set = Array{Int}(undef, height, width)

    @inbounds @threads for i in 1:height
        for j in 1:width
            set[i, j] = mandelbrot(A[i, j], max_iter)
        end
    end

    return set
end

end
