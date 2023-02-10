"""
# The Brusselator Equation in 2D

A 2D version of the Brusselator equation, which is a model for the formation of a pattern in a chemical reaction.
The reaction is between two chemicals, A and B, which are produced and consumed by the reaction.
The reaction is autocatalytic, meaning that the production of A and B is dependent on the concentration of A and B.
The reaction is also bistable, meaning that there are two stable states for the system.
The system is initialized with a small perturbation in the concentration of A, which causes the system to evolve.
The system is then perturbed again, eventually forming a bistable state.
This is a classic example of a pattern forming chemical reaction.

The Brusselator equation is given by:

```math
\\frac{\\partial u}{\\partial t} = 1 + v u^2 - 4.4 u + \\alpha \\Delta u + f(x, y, t)
```

```math
\\frac{\\partial v}{\\partial t} = 3.4 - vu^2 + u^2 + \\alpha \\Delta v
```

where ``\\alpha`` is a parameter that controls the diffusion of the system, and ``f(x, y, t)`` is a forcing term.

The initial conditions are given by:

```math
u(x, y, 0) = 22(y (1 - y))^{\\frac{3}{2}}
```

```math
v(x, y, 0) = 27(x (1 - x))^{\\frac{3}{2}}
```

The boundary conditions are periodic in both ``x`` and ``y``.
"""
bruss = begin
    @parameters x y t
    @variables u(..) v(..)
    Dt = Differential(t)
    Dx = Differential(x)
    Dy = Differential(y)
    Dxx = Differential(x)^2
    Dyy = Differential(y)^2

    ∇²(u) = Dxx(u) + Dyy(u)

    brusselator_f(x, y, t) = (((x - 0.3)^2 + (y - 0.6)^2) <= 0.1^2) * (t >= 1.1) * 5.0

    x_min = y_min = t_min = 0.0
    x_max = y_max = 1.0
    t_max = 11.5

    α = 10.0

    u0(x, y, t) = 22(y * (1 - y))^(3 / 2)
    v0(x, y, t) = 27(x * (1 - x))^(3 / 2)

    eq = [
        Dt(u(x, y, t)) ~ 1.0 + v(x, y, t) * u(x, y, t)^2 - 4.4 * u(x, y, t) +
                         α * ∇²(u(x, y, t)) + brusselator_f(x, y, t),
        Dt(v(x, y, t)) ~ 3.4 * u(x, y, t) - v(x, y, t) * u(x, y, t)^2 + α * ∇²(v(x, y, t))]

    domains = [x ∈ Interval(x_min, x_max),
        y ∈ Interval(y_min, y_max),
        t ∈ Interval(t_min, t_max)]

    bcs = [u(x, y, 0) ~ u0(x, y, 0),
        u(0, y, t) ~ u(1, y, t),
        u(x, 0, t) ~ u(x, 1, t), v(x, y, 0) ~ v0(x, y, 0),
        v(0, y, t) ~ v(1, y, t),
        v(x, 0, t) ~ v(x, 1, t)]

    @named bruss = PDESystem(eq, bcs, domains, [x, y, t], [u(x, y, t), v(x, y, t)])

    bruss
end

push!(all_systems, bruss)
push!(nonlinear_systems, bruss)