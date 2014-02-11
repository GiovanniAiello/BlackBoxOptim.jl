using BlackBoxOptim

# Another problem from Hans W. Borchers, constrained 15-points:
function points15(x)
    d = 2.0
    for i = 1:14, j = (i+1):15
        s = (x[i]-x[j])^2 + (x[i+15]-x[j+15])^2 + (x[i+30]-x[j+30])^2
        s = sqrt(s)
        if s < d
          d = s
        end
    end
    return -d
end

# This is a hard problem so run for some time...
MaxMinutes = 2

# Run AdaptiveDE
bboptimize(points15, (0.0, 1.0); dimensions = 45, max_time = MaxMinutes * 60)

# To run XNES on it we need to add a penalty for going outside the (0,1) box.
function penalty(x, range)
  lower = x .< range[1]
  higher = x .> range[2]
  100 * (norm(range[1] - x[lower]) + norm(x[higher] - range[2]))
end

penalized_points15(x) = points15(x) + penalty(x, (0.0, 1.0))

# Run XNES
best, fitness = bboptimize(penalized_points15, (0.0, 1.0); dimensions = 45, 
  max_time = MaxMinutes * 60, method = :xnes)

println("points15 fitness = ", points15(best))