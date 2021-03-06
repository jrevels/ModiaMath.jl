within ;
package ModelicaReferenceModels
  model FreeBodyRotation
    import Modelica.Math.sin;
    parameter Real m=1.0;
    parameter Real I11=1.0;
    parameter Real I22=2.0;
    parameter Real I33=3.0;
    parameter Real g=0;
    parameter Real freqHz[3]={0.3,0.2,0.1};
    parameter Real A[3]={3,4,5};
    parameter Real phase[3]={0,0.5235987755983,1.0471975511966};
    final parameter Real I[3,3] = diagonal({I11,I22,I33});
    constant Real pi=Modelica.Constants.pi;
    Real Q[4](start={0.08908708063747484, 0.445435403187374, 0.0, 0.8908708063747479});
    Real w[3](start={0,0,0},fixed=true);
    Real z[3];
    Real u[3];
  equation
    u = A.*sin(2*pi*freqHz*time + phase);

    w = 2*([Q[4], Q[3], -Q[2], -Q[1];
           -Q[3], Q[4], Q[1], -Q[2];
            Q[2], -Q[1], Q[4], -Q[3]])*der(Q);
    0 = Q*Q-1;

    der(w) = z;
    I*z + cross(w, I*w) = u;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=5, Tolerance=1e-008));
  end FreeBodyRotation;

  model FreeBodyRotation2
    import Modelica.Math.sin;
    parameter Real m=1.0;
    parameter Real I11=1.0;
    parameter Real I22=2.0;
    parameter Real I33=3.0;
    parameter Real g=0;
    parameter Real freqHz[3]={0.3,0.2,0.1};
    parameter Real A[3]={3,4,5};
    parameter Real phase[3]={0,0.5235987755983,1.0471975511966};
    final parameter Real I[3,3] = diagonal({I11,I22,I33});
    constant Real pi=Modelica.Constants.pi;
    Real Q[4](start={0.08908708063747484, 0.445435403187374, 0.0, 0.8908708063747479});
    Real w[3](start={0,0,0},fixed=true);
    Real z[3];
    Real u[3];
    inner Modelica.Mechanics.MultiBody.World world(g=g)
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Modelica.Mechanics.MultiBody.Parts.BodyShape
                                            body(
      r_CM={0,0,0},
      m=m,
      I_11=I11,
      I_22=I22,
      I_33=I33,
      angles_fixed=true,
      w_0_fixed=true,
      r_0(fixed=true),
      v_0(fixed=true),
      r={0,0,0},
      shapeType="box",
      length=0.2,
      width=0.3,
      height=0.4,
      animateSphere=false)
                annotation (Placement(transformation(extent={{20,20},{40,40}})));
    Modelica.Mechanics.MultiBody.Forces.WorldTorque torque(resolveInFrame=
          Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b)
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    Modelica.Blocks.Sources.Sine sine[3](
      freqHz=freqHz,
      amplitude=A,
      phase=phase)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  equation
    u = A.*sin(2*pi*freqHz*time + phase);

    w = 2*([Q[4], Q[3], -Q[2], -Q[1];
           -Q[3], Q[4], Q[1], -Q[2];
            Q[2], -Q[1], Q[4], -Q[3]])*der(Q);
    0 = Q*Q-1;

    der(w) = z;
    I*z + cross(w, I*w) = u;

    connect(body.frame_a, torque.frame_b) annotation (Line(
        points={{20,30},{10,30}},
        color={95,95,95},
        thickness=0.5));
    connect(torque.torque, sine.y) annotation (Line(points={{-12,30},{-19,30}},
                                color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=5, Tolerance=1e-008));
  end FreeBodyRotation2;

  model PendulumDAE
    parameter Real L=1;
    parameter Real m=1.0;
    parameter Real g=9.81;
    parameter Real x0 = 0.7071067953286823;
    Real x(start=x0, fixed=true);
    Real y(start=-0.7071067670444124);
    Real lambda;
    Real vx(start=0.9999999309500006, fixed=true);
    Real vy(start=0.9999999709499966);
  equation
    vx = der(x);
    vy = der(y);
    m*der(vx) = -lambda*x;
    m*der(vy) = -lambda*y-m*g;
    x*x + y*y = L*L;

    annotation (experiment(StopTime=2,Tolerance=1e-008));
  end PendulumDAE;

  model PendulumDAE2 "Same as PendulumDAE, but with other start values"
    extends PendulumDAE(x0=0.5,vx(start=1.0),
                        y(start=-0.8660254037844387),
                        vy(start=0.5773502691896257));
    annotation (experiment(StopTime=2,Tolerance=1e-008));
  end PendulumDAE2;

  model PendulumODE
    Real L=0.5;
    Real m=1.0;
    Real d=0.1;
    Real g=9.81;
    Real phi(start=60*Modelica.Constants.pi/180, fixed=true);
    Real w;
  equation
    w = der(phi);
    m*L^2*der(w) + m*g*L*sin(phi) + d*w = 0;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=10, Tolerance=1e-008));
  end PendulumODE;

  model SimpleStateEvents
    parameter Real m=1;
    parameter Real k=1;
    parameter Real d=0.1;
    parameter Real fMax = 1.5;
    Real x(start=2.0, fixed=true);
    Real v(start=0, fixed=true);
    Real f;
  equation
    f = if x > 0 then 0 else fMax;
    v = der(x);
    m*der(v) + d*v + k*x = f
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));

    annotation (experiment(StopTime=5), __Dymola_experimentSetupOutput);
  end SimpleStateEvents;

  model BouncingBall
     parameter Real g=9.81;
     parameter Real e=0.7;
     Real h(start=1, fixed=true);
     Real v(start=0, fixed=true);
     Boolean flying(start=true,fixed=true);
  equation
     der(h) = v;
     der(v) = if flying then -g else 0;

     when h <= 0 then
       flying = -e*pre(v) > 0.01;
       reinit(v, if flying then -e*pre(v) else 0.0);
     end when;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=3));
  end BouncingBall;

  model HeatTransfer3D
    "2-dimensional heat transfer. Two ends with different temperatures, two ends isolated"
    import Modelica.SIunits;
    parameter SIunits.Length L = 0.2 "Length in x-, y-, and z-direction";
    parameter Integer N = 10 "Number of nodes in x-, y-, and z-direction";
    parameter SIunits.Temperature T0=290 "Initial temperature";
    parameter SIunits.Temperature TNx = 310 "Temperature along the yz-area outside x-node N";
    parameter SIunits.Temperature TNy = 330 "Temperature along the xz-area outside y-node N";
    parameter SIunits.Temperature TNz = 350 "Temperature along the xy-area outside z-node N";
    parameter SIunits.SpecificHeatCapacity cp=910 "Material Heat Capacity";
    parameter SIunits.ThermalConductivity lambda=237
      "Material thermal conductivity";
    parameter Modelica.SIunits.Density rho=271 "Material Density";
    final parameter Modelica.SIunits.Length dL = L / N "Element length in x- and y-direction";

    /* Q = lambda*A/L = lambda*(Ti - Tj)*dL*dL/dL
                    = lambda*(Ti - Tj)*dL
     cp*m*der(T) = cp*rho*dL^3*der(T)
     der(T) = sum(Q)/(cp*rho*dL^3)
            = sum(Ti-Tj)*lambda*dL/(cp*rho*dL^3)
            = sum(Ti-Tj)*lambda/(cp*rho*dL^2)
            
    Boundary condition
      Q = lambda*(TN - Ti)*dL*dL/(dL/2)
        = 2*lambda*(TN - Ti)*dL 
  */
    final parameter Real c = lambda/(cp*rho*dL*dL);
    SIunits.Temperature T[N,N,N](each start=T0, each fixed=true) "Initial temperatures of the nodes";
    SIunits.TemperatureDifference qx1, qx2, qy1, qy2, qz1, qz2;
  algorithm
    for i in 1:N loop
      for j in 1:N loop
         for k in 1:N loop
            // Q = lambda*area/length
            qx1 :=if i > 1 then T[i - 1, j, k] - T[i,j,k] else 0.0;
            qx2 :=if i < N then T[i + 1, j, k] - T[i,j,k] else 2*(TNx - T[i,j,k]);
            qy1 :=if j > 1 then T[i, j - 1, k] - T[i,j,k] else 0.0;
            qy2 :=if j < N then T[i, j + 1, k] - T[i,j,k] else 2*(TNy - T[i,j,k]);
            qz1 :=if k > 1 then T[i, j, k - 1] - T[i,j,k] else 0.0;
            qz2 :=if k < N then T[i, j, k + 1] - T[i,j,k] else 2*(TNz - T[i,j,k]);

            der(T[i,j,k]) :=c*(qx1 + qx2 + qy1 + qy2 + qz1 + qz2);
         end for;
      end for;
    end for;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=30));
  end HeatTransfer3D;

  model HeatTransfer2D
    "2-dimensional heat transfer. Two ends with different temperatures, two ends isolated"
    import Modelica.SIunits;
    parameter SIunits.Length L = 0.2 "Length in x-, y-, and z-direction";
    parameter Integer N = 10 "Number of nodes in x-, y-, and z-direction";
    parameter SIunits.Temperature T0=290 "Initial temperature";
    parameter SIunits.Temperature TNx = 310 "Temperature along the yz-area outside x-node N";
    parameter SIunits.Temperature TNy = 330 "Temperature along the xz-area outside y-node N";
    parameter SIunits.Temperature TNz = 350 "Temperature along the xy-area outside z-node N";
    parameter SIunits.SpecificHeatCapacity cp=910 "Material Heat Capacity";
    parameter SIunits.ThermalConductivity lambda=237
      "Material thermal conductivity";
    parameter Modelica.SIunits.Density rho=2712 "Material Density";
    final parameter Modelica.SIunits.Length dL = L / N "Element length in x- and y-direction";

    /* Q = lambda*A/L = lambda*(Ti - Tj)*dL*Lz/dL
                    = lambda*(Ti - Tj)*Lz
     cp*m*der(T) = cp*rho*dL^2*Lz*der(T)
     der(T) = sum(Q)/(cp*rho*dL^2*Lz)
            = sum(Ti-Tj)*lambda*Lz/(cp*rho*dL^2*Lz)
            = sum(Ti-Tj)*lambda/(cp*rho*dL^2)
            
    Boundary condition
      Q = lambda*(TN - Ti)*dL*Lz/(dL/2)
        = 2*lambda*(TN - Ti)*Lz 
  */
    final parameter Real c = lambda/(cp*rho*dL*dL);
    SIunits.Temperature T[N,N](each start=T0, each fixed=true) "Initial temperatures of the nodes";
    SIunits.TemperatureDifference qx1, qx2, qy1, qy2;
  algorithm
    for i in 1:N loop
      for j in 1:N loop
          // Q = lambda*area/length
          qx1 :=if i > 1 then T[i - 1, j] - T[i,j] else 0.0;
          qx2 :=if i < N then T[i + 1, j] - T[i,j] else 2*(TNx - T[i,j]);
          qy1 :=if j > 1 then T[i, j - 1] - T[i,j] else 0.0;
          qy2 :=if j < N then T[i, j + 1] - T[i,j] else 2*(TNy - T[i,j]);
          der(T[i,j]) :=c*(qx1 + qx2 + qy1 + qy2);
      end for;
    end for;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=500));
  end HeatTransfer2D;

  model PT1
    Modelica.Blocks.Continuous.FirstOrder firstOrder(
      T=0.1,
      initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=1.5)
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  equation
    connect(const.y, firstOrder.u)
      annotation (Line(points={{-59,50},{-50,50},{-42,50}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=10));
  end PT1;

  model LoopWithPrismaticJoints
    parameter Real m=1;
    parameter Real[3] n1={1,0,0};
    parameter Real[3] n2={0,1,0};
    parameter Real[3] n3={0,0,1};
    parameter Real[3] n4={1,1,1};
    Real[3] r0;
    Real[3] r1;
    Real[3] r2;
    Real[3] r3;
    Real[3] r4;
    Real[3] rbody;
    Real[3] vbody;
    Real[3] abody;
    Real[3] fbody;
    Real[3] f0;
    Real[3] f1a;
    Real[3] f1b;
    Real[3] f2a;
    Real[3] f2b;
    Real[3] f3a;
    Real[3] f3b;
    Real[3] f4a;
    Real[3] f4b;
    Real s1,s2,s3,s4;
    Real sd1, sd2, sd3, sd4;
    Real sdd1, sdd2, sdd3, sdd4;

  equation
  // kinematics
  r0 = zeros(3);
  r1 = r0 + n1*s1;
  r2 = r1 + n2*s2;
  r3 = r2 + n3*s3;
  r4 = r0 + n4*s4;
  r3 = r4;

  sd1 = der(s1);
  sd2 = der(s2);
  sd3 = der(s3);
  sd4 = der(s4);

  sdd1 = der(sd1);
  sdd2 = der(sd2);
  sdd3 = der(sd3);
  sdd4 = der(sd4);

  rbody = r4;
  vbody = der(rbody);
  abody = der(vbody);

  // force balances
  zeros(3) = f1a + f1b;
  zeros(3) = f2a + f2b;
  zeros(3) = f3a + f3b;
  zeros(3)  = f4a + f4b;
  m*abody = fbody;

  // connects
  zeros(3) = f0 + f1a + f4a;
  zeros(3) = f1b + f2a;
  zeros(3) = f2b + f3a;
  zeros(3) = f3b + f4b + fbody;

  // projection equations
  0 = n1*f1b;
  0 = n2*f2b;
  0 = n3*f3b;
  sin(time) = n4*f4b;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end LoopWithPrismaticJoints;

  package HigherIndexModels

    model Pendulum_Index3
      parameter Real L=1;
      parameter Real m=1.0;
      parameter Real g=9.81;
      parameter Real x0 = L/2;
      Real x(start=x0, fixed=true);
      Real y(start=-sqrt(L^2 - x0^2));
      Real lambda;
      Real vx(start=0, fixed=true);
      Real vy;
    equation
      vx = der(x);
      vy = der(y);
      m*der(vx) = -lambda*x;
      m*der(vy) = -lambda*y-m*g;
      x*x + y*y = L*L;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=2));
    end Pendulum_Index3;

    model InverseElasticJoint_Index5
      parameter Real J1=1;
      parameter Real J2=2;
      parameter Real c=1e-5;
      parameter Real fFilter=2;
      parameter Real d=1;
      Real phi1, phi2, phi1_ref;
      Real w1, w2;
      Real tau;
      Real tauJoint;
      Modelica.Blocks.Continuous.CriticalDamping criticalDamping(f=fFilter, n=3)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    equation
      w1 = der(phi1);
      w2 = der(phi2);
      tauJoint = c*(phi1-phi2) + d*(w1-w2);
      J1*der(w1) + tauJoint = 0;
      J2*der(w2) - tauJoint = tau;
      criticalDamping.u = phi1_ref;
      phi1 = criticalDamping.y;
      phi1_ref = if time < 1 then time else 1.0;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end InverseElasticJoint_Index5;

    model InverseElasticJoint_Index4
      parameter Real J1=1;
      parameter Real J2=2;
      parameter Real c=1e-5;
      parameter Real fFilter=2;
      parameter Real d=1;
      Real phi1(start=0,fixed=true), phi2(start=0,fixed=true), w1_ref;
      Real w1(start=0,fixed=true), w2(start=0,fixed=true);
      Real tau;
      Real tauJoint;

      final parameter Real alpha=sqrt(sqrt(2) - 1);
      final parameter Real wFilter=2*Modelica.Constants.pi*fFilter/alpha;
      Real x1, x2;
    equation
      w1_ref = if time < 0.1 then 0.0 else 1.0;

      // Critical damping filter
      der(x1) = (w1_ref - x1)*wFilter;
      der(x2) = (x1 - x2)*wFilter;
      w1 = x2;

      // Two inertias with elastic joint
      w1 = der(phi1);
      w2 = der(phi2);
      tauJoint = c*(phi1-phi2) + d*(w1-w2);
      J1*der(w1) + tauJoint = 0;
      J2*der(w2) - tauJoint = tau;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end InverseElasticJoint_Index4;

    model InverseElasticJoint_Index4b
      parameter Real J1=1;
      parameter Real J2=2;
      parameter Real c=1e-5;
      parameter Real fFilter=2;
      parameter Real d=1;
      Real phi1(start=0,fixed=true), phi2(start=0,fixed=true), w1_ref;
      Real w1(start=0,fixed=true), w2(start=0,fixed=true);
      Real tau;
      Real tauJoint;

      final parameter Real alpha=sqrt(sqrt(2) - 1);
      final parameter Real wFilter=2*Modelica.Constants.pi*fFilter/alpha;
      Real x1, x2;
    equation
      w1_ref = if time < 0.1 then 0.0 else 1.0;

      // Critical damping filter
      der(x1) = (w1_ref - x1)*wFilter;
      der(x2) = (x1 - x2)*wFilter;
      w1 = x2;

      // Two inertias with elastic joint
      w1 = der(phi1);
      w2 = der(phi2);
      tauJoint = c*(phi1-phi2) + d*(w1-w2);
      J1*der(w1) + tauJoint = 0;
      J2*der(w2) - tauJoint = tau;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end InverseElasticJoint_Index4b;

    model SimpleIndex4
       parameter Real m=1;
       parameter Real c=10;
       parameter Real d=1;
       Real s(start=1,fixed=true),v,a,ad;
    equation
        der(s) = v;
        der(v) = a;
        der(a) = ad;
        m*a + d*v + c*s = 0;

        /*
    Pantelide gives the following equations:
    
    der(s) = v;
    der(v) = a;
    der(a) = ad;
    m*a + d*v + c*s = 0;
    m*der(a) + d*der(v) + c*der(s) = 0;
    
    Highest derivative variables:
    der(a), ad
    
    
    
    Solve first:
    der(s) = v;
    der(v) = a;
    m*a + d*v + c*s = 0;
    
    Then:
    m*ad + d*a + c*v = 0 -> ad = (-d*a - c*v)/m
    */
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end SimpleIndex4;

    model SimpleAlgebraicIndex4
      parameter Real m=1.0;
      parameter Real n[3]={1,0,0};
      Real s;
      Real[3] rbody;
      Real[3] vbody;
      Real[3] abody;
      Real[3] abodyd;
      Real[3] f;
    equation
      rbody = n*s;
      vbody = der(rbody);
      abody = der(vbody);
      m*abody = f;
      sin(time)=n*f;
      abodyd = der(abody);

      /*
  Solve first:
  
  rbody = n*s;
  vbody = der(rbody);
  m*abody = f;
  sin(time)=n*f;
    
  Then:
  m*der(abody)= der(f)
  cos(time) = n*der(f)
  abodyd = der(abody)
  */

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end SimpleAlgebraicIndex4;

    model DummyDerivative
      Real u1, u2, u3, u4;
      Real x1, x2(start=0,fixed=true), x3, x4;
      Real x1d, x2d(start=0,fixed=true), x3d;
    equation
      u1=sin(11*time);
      u2=sin(22*time);
      u3=sin(33*time);
      u4=sin(44*time);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);

      x1 + x2 + u1 = 0;
      x1 + x2 + x3 + u2 = 0;
      x1 + x3d + x4 + u3 = 0;
      2*der(x1d) + der(x2d) + der(x3d) + der(x4) + u4 = 0;





      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DummyDerivative;

    model DummyDerivative2
      parameter Real g11=1;
      parameter Real g12=1;
      parameter Real g21=1;
      parameter Real g22=1;
      parameter Real g33=1;
      Real u1, u2, u3, u4;
      Real x1, x2(start=0,fixed=true), x3, x4;
      Real x1d, x2d(start=0, fixed=true), x3d;
      Real x1p, x2p, x3p;
      Real mue1, mue2;
    equation
      u1=sin(11*time);
      u2=sin(22*time);
      u3=sin(33*time);
      u4=sin(44*time);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);

      x1p = x1d + g11*mue1 + g12*mue2;
      x2p = x2d + g21*mue1 + g22*mue2;
      x3p = x3d +            g33*mue2;

      0 = u1 + x1 + x2;
      0 = u2 + x1 + x2 + x3;

      0 = der(u1) + x1p + x2p;
      0 = der(u2) + x1p + x2p + x3p;
      0 = u3 + x1 + x3p + x4;

      0 = u4 + 2*der(x1p) + der(x2p) + der(x3p) + der(x4);

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DummyDerivative2;

    model DummyDerivative2b
      parameter Real g11=1;
      parameter Real g12=1;
      parameter Real g21=1;
      parameter Real g22=1;
      parameter Real g33=1;
      Real u1, u2, u3, u4;
      Real x1, x2, x3, x4;
      Real x1d, x2d, x3d;
      Real x1p, x2p, x3p;
      Real mue1, mue2;
    equation
      u1=sin(11*time);
      u2=sin(22*time);
      u3=sin(33*time);
      u4=sin(44*time);

      x1d = x1;
      x2d = x2;
      x3d = x3;

      x1p = x1d + g11*mue1 + g12*mue2;
      x2p = x2d + g21*mue1 + g22*mue2;
      x3p = x3d +            g33*mue2;

      0 = u1 + x1 + x2;
      0 = u2 + x1 + x2 + x3;

      0 = der(u1) + x1p + x2p;
      0 = der(u2) + x1p + x2p + x3p;
      0 = u3 + x1 + x3p + x4;

      0 = u4 + 2*x1p + x2p + x3p + x4;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DummyDerivative2b;

    model DummyDerivativeB
      Real u1, u2, u3, u4, u5;
      Real x1, x2(start=0, fixed=true), x3, x4, x5;
      Real x1d, x2d(start=0, fixed=true), x3d, x5d, x5dd;
    equation
      u1=sin(1.1*time);
      u2=sin(1.2*time);
      u3=sin(1.3*time);
      u4=sin(1.4*time);
      u5=sin(1.5*time);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);
      x5d = der(x5);
      x5dd = der(x5d);

      0 = u1 + x1 + x2;
      0 = u2 + x1 + x2 + x3 + x5d;
      0 = u3 + x1 + x3d + x4;
      0 = u4 + 2*der(x1d) + der(x2d) + der(x3d) + der(x4) + der(x5dd);
      0 = u5 + 2*x5;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DummyDerivativeB;

    model DummyDerivativeB2
      parameter Real g11=1;
      parameter Real g12=1;
      parameter Real g21=1;
      parameter Real g22=1;
      parameter Real g33=1;
      parameter Real g51=2;

      Real u1, u2, u3, u4, u5, u5d;
      Real x1, x2(start=0, fixed=true), x3, x4, x5;
      Real x1d, x2d(start=0, fixed=true), x3d, x5d, x5dd;
      Real x1p, x2p, x3p, x5p, x5pp;
      Real mue1, mue2, mue3, mue4;
    equation
      u1=sin(1.1*time);
      u2=sin(1.2*time);
      u3=sin(1.3*time);
      u4=sin(1.4*time);
      u5=sin(1.5*time);
      u5d=der(u5);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);
      x5d = der(x5);
      x5dd = der(x5d);

      x1p  = x1d + g11*mue1 + g12*mue2;
      x2p  = x2d + g21*mue1 + g22*mue2;
      x3p  = x3d +            g33*mue2;
      x5p  = x5d + g51*mue3;
      x5pp = x5p + g51*mue4;   // g51 is used in both x5p and x5pp

      0 = u5 + 2*x5;
      0 = u5d + 2*x5p;
      0 = der(u5d) + 2*x5pp;

      0 = u1 + x1 + x2;
      0 = u2 + x1 + x2 + x3 + x5p;

      0 = der(u1) + x1p + x2p;
      0 = der(u2) + x1p + x2p + x3p + x5pp;
      0 = u3 + x1 + x3d + x4;

      0 = u4 + 2*der(x1d) + der(x2d) + der(x3d) + der(x4) + der(x5pp);

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=1.5));
    end DummyDerivativeB2;

    model DummyDerivativeB2b
      parameter Real g11=1;
      parameter Real g12=1;
      parameter Real g21=1;
      parameter Real g22=1;
      parameter Real g33=1;
      parameter Real g51=2;

      Real u1, u2, u3, u4, u5, u5d;
      Real x1, x2, x3, x4, x5;
      Real x1d, x2d, x3d, x4d, x5d, x5dd;
      Real x1p, x2p, x3p, x5p, x5pp;
      Real mue1, mue2, mue3, mue4;

      function f
         input Real u;
         output Real y;
         external "C" y=f(u);
      end f;
    equation
      u1=sin(1.1*time);
      u2=sin(1.2*time);
      u3=sin(1.3*time);
      u4=sin(1.4*time);
      u5=sin(1.5*time);
      u5d=der(u5);

      x1d = x1;
      x2d = x2;
      x3d = x3;
      x4d = x4;
      x5d = x5;
      x5dd =x5d;

      x1p  = x1d + g11*mue1 + g12*mue2;
      x2p  = x2d + g21*mue1 + g22*mue2;
      x3p  = x3d +            g33*mue2;
      x5p  = x5d + g51*mue3;
      x5pp = x5p + g51*mue4;   // g51 is used in both x5p and x5pp

      0 = u5 + 2*x5;
      0 = u5d + 2*x5p;
      0 = der(u5d) + 2*x5pp;

      0 = u1 + x1 + x2;
      0 = u2 + x1 + x2 + x3 + x5p;

      0 = der(u1) + x1p + x2p;
      0 = der(u2) + x1p + x2p + x3p + x5pp;
      0 = u3 + x1 + x3d + x4;

      0 = u4 + 2*x1d + x2d + x3d + x4d + x5pp;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=1.5));
    end DummyDerivativeB2b;

    model SimpleODAE1
      Real u1, u2, u3, u4;
      Real x1, x2(start=0, fixed=true), x3, x4;
      Real x1d, x2d(start=0, fixed=true), x3d;
    equation
      u1=sin(1.1*time);
      u2=sin(1.2*time);
      u3=sin(1.3*time);
      u4=sin(1.4*time);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);

      0 = u1 + x1 + x2;
      0 = u2 + x1 + x2 + x3;
      0 = u3 + x1 + x3d + x4;
      0 = u4 + 2*der(x1d) + der(x2d) + der(x3d) + der(x4);
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=1.0, Tolerance=1e-008));
    end SimpleODAE1;

    model DummyDerivative3a
      Real u1, u2, u3, u4, u5, u6, u7;
      Real x1, x2(start=0, fixed=true), x3, x4, x5, x6, x7;
      Real x1d, x2d(start=0, fixed=true), x3d, x6d, x6dd;
    equation
      u1=sin(1.1*time);
      u2=sin(1.2*time);
      u3=sin(1.3*time);
      u4=sin(1.4*time);
      u5=sin(1.5*time);
      u6=sin(1.6*time);
      u7=sin(1.7*time);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);
      x6d = der(x6);
      x6dd = der(x6d);

      0 = u1 + x1 - x2;
      0 = u2 + x1 + x2 - x3 + x6d;
      0 = u3 + x1 + x3d - x4;
      0 = u4 + 2*der(x1d) + der(x2d) + der(x3d) + der(x4) + der(x6dd);
      0 = u5 + 3*der(x1d) + 2*der(x2d) + x5;
      0 = u6 + 2*x6 + x7;
      0 = u7 + 3*x6 + 4*x7
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));

    end DummyDerivative3a;
  end HigherIndexModels;

  package Friction
    model ReferenceModel
      Modelica.Mechanics.Rotational.Components.Inertia inertia(
        J=2,
        phi(fixed=true, start=0),
        w(fixed=true, start=0))
        annotation (Placement(transformation(extent={{-20,20},{0,40}})));
      Modelica.Mechanics.Rotational.Sources.Torque torque
        annotation (Placement(transformation(extent={{-46,20},{-26,40}})));
      Modelica.Blocks.Sources.Sine sine(freqHz=2, amplitude=1.3)
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction
        annotation (Placement(transformation(extent={{8,20},{28,40}})));
    equation
      connect(inertia.flange_a, torque.flange)
        annotation (Line(points={{-20,30},{-24,30},{-26,30}}, color={0,0,0}));
      connect(torque.tau, sine.y) annotation (Line(points={{-48,30},{-54,30},{
              -59,30}}, color={0,0,127}));
      connect(inertia.flange_b, bearingFriction.flange_a)
        annotation (Line(points={{0,30},{8,30}}, color={0,0,0}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ReferenceModel;

    model fvParameterization
      parameter Real J=2;
      parameter Real A=1.3;
      parameter Real freq=2;
      parameter Real tauMax=1;
      Real u;
      Real w(start=0,fixed=true);
      Real s;
      Real tau;
    equation
      u = A*sin(2*Modelica.Constants.pi*freq);

      J*der(w) = u-tau;
      tau = if s >=  tauMax then  tauMax  else
            if s <= -tauMax then -tauMax  else s;
        w = if s >=  tauMax then s-tauMax else
            if s <= -tauMax then s+tauMax else 0;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end fvParameterization;

    model fvParameterization2
      parameter Real J=2;
      parameter Real A=1.3;
      parameter Real freq=2;
      parameter Real tauMax=1;
      Real u;
      Real w(start=0,fixed=true);
      Real s(start=0);
      Real tau;

      function friction
         input Real s;
         input Real tauMax;
         output Real w;
         output Real tau;
      algorithm
          tau :=if s >= tauMax then tauMax else if s <= -tauMax then -tauMax
           else s;
            w :=if s >= tauMax then s - tauMax else if s <= -tauMax then s +
          tauMax else 0;
      end friction;
    equation
      u = A*sin(2*Modelica.Constants.pi*freq);

      J*der(w) = u-tau;
      (w,tau) = friction(s,tauMax);

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end fvParameterization2;
  end Friction;

  package ODAEs

    model Pendulum
      parameter Real L=1;
      parameter Real m=1.0;
      parameter Real g=9.81;
      parameter Real x0 = L/2;
      Real x(start=x0, fixed=true);
      Real y(start=-sqrt(L^2 - x0^2));
      Real lambda;
      Real vx(start=0, fixed=true);
      Real vy;
      Real phi;
      inner Modelica.Mechanics.MultiBody.World world(g=g)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Mechanics.MultiBody.Joints.Revolute rev(w(fixed=true), phi(
          fixed=true,
          displayUnit="rad",
          start=asin(x0/L)))
        annotation (Placement(transformation(extent={{-46,40},{-26,60}})));
      Modelica.Mechanics.MultiBody.Parts.PointMass pointMass(m=m) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={-10,10})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation fixedTranslation(r={0,-L,0})
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={-10,32})));
    equation
      vx = der(x);
      vy = der(y);
      m*der(vx) = -x*lambda;
      m*der(vy) = -y*lambda-m*g;
      x*x + y*y = L*L;
      phi = atan2(x,-y);

      connect(world.frame_b, rev.frame_a) annotation (Line(
          points={{-60,50},{-54,50},{-46,50}},
          color={95,95,95},
          thickness=0.5));
      connect(pointMass.frame_a, fixedTranslation.frame_b) annotation (Line(
          points={{-10,10},{-10,10},{-10,22}},
          color={95,95,95},
          thickness=0.5));
      connect(rev.frame_b, fixedTranslation.frame_a) annotation (Line(
          points={{-26,50},{-10,50},{-10,42}},
          color={95,95,95},
          thickness=0.5));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=2));
    end Pendulum;

    model FreeBody
      import Modelica.Math.sin;
      parameter Real m=1.0;
      parameter Real I11=1.0;
      parameter Real I22=2.0;
      parameter Real I33=3.0;
      parameter Real g=0;
      parameter Real freqHz[3]={0.3,0.2,0.1};
      parameter Real A[3]={3,4,5};
      parameter Real phase[3]={0,0.5235987755983,1.0471975511966};
      final parameter Real I[3,3] = diagonal({I11,I22,I33});
      constant Real pi=Modelica.Constants.pi;
      Real Q[4](start={0,0,0,1});
      Real w[3](start={0,0,0},fixed=true);
      Real z[3];
      Real u[3];
      inner Modelica.Mechanics.MultiBody.World world(g=g)
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica.Mechanics.MultiBody.Parts.BodyShape
                                              body(
        r_CM={0,0,0},
        m=m,
        I_11=I11,
        I_22=I22,
        I_33=I33,
        angles_fixed=true,
        w_0_fixed=true,
        r_0(fixed=true),
        v_0(fixed=true),
        r={0,0,0},
        shapeType="box",
        length=0.2,
        width=0.3,
        height=0.4,
        animateSphere=false)
                  annotation (Placement(transformation(extent={{20,20},{40,40}})));
      Modelica.Mechanics.MultiBody.Forces.WorldTorque torque(resolveInFrame=
            Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b)
        annotation (Placement(transformation(extent={{-10,20},{10,40}})));
      Modelica.Blocks.Sources.Sine sine[3](
        freqHz=freqHz,
        amplitude=A,
        phase=phase)
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    equation
      u = A.*sin(2*pi*freqHz*time + phase);

      w = 2*([Q[4], Q[3], -Q[2], -Q[1];
             -Q[3], Q[4], Q[1], -Q[2];
              Q[2], -Q[1], Q[4], -Q[3]])*der(Q);
      0 = Q*Q-1;

      der(w) = z;
      I*z + cross(w, I*w) = u;


      connect(body.frame_a, torque.frame_b) annotation (Line(
          points={{20,30},{10,30}},
          color={95,95,95},
          thickness=0.5));
      connect(torque.torque, sine.y) annotation (Line(points={{-12,30},{-19,30}},
                                  color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=5, Tolerance=1e-008));
    end FreeBody;

    model SimpleODAE
      Real u1, u2, u3, u4, u5, u6;
      Real x1, x2(start=0, fixed=true), x3, x4, x5, x6;
      Real x1d, x2d(start=0, fixed=true), x3d, x5d, x5dd;
    equation
      u1=sin(1.1*time);
      u2=sin(1.2*time);
      u3=sin(1.3*time);
      u4=sin(1.4*time);
      u5=sin(1.5*time);
      u6=sin(1.6*time);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);
      x5d = der(x5);
      x5dd = der(x5d);

      0 = u1 + x1 + x2;
      0 = u2 + x1 + x2 + x3 + x5d;
      0 = u3 + x1 + x3d + x4;
      0 = u4 + 2*der(x1d) + der(x2d) + der(x3d) + der(x4) + der(x5dd);
      0 = u5 + 2*x5 + x6;
      0 = u6 + 3*x5 + 4*x6;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=1.0, Tolerance=1e-008));
    end SimpleODAE;

    model SimpleODAE2
      Real u1, u2, u3, u4, u5, u6, u7, u8;
      Real x1, x2(start=0, fixed=true), x3, x4, x5, x6, x7, x8;
      Real x1d, x2d(start=0, fixed=true), x3d, x6d, x6dd;
    equation
      u1=sin(1.1*time);
      u2=sin(1.2*time);
      u3=sin(1.3*time);
      u4=sin(1.4*time);
      u5=sin(1.5*time);
      u6=sin(1.6*time);
      u7=sin(1.7*time);
      u8=sin(1.8*time);

      x1d = der(x1);
      x2d = der(x2);
      x3d = der(x3);
      x6d = der(x6);
      x6dd = der(x6d);

      0 = u1 + x1 - x2;
      0 = u2 + x1 + x2 - x3 + x6d;
      0 = u3 + x1 + x3d - x4;
      0 = u4 + 2*der(x1d) + der(x2d) + der(x3d) + der(x4) + der(x6dd);
      0 = u5 + 3*der(x1d) + 2*der(x2d) + x5 + 0.1*x8;
      0 = u6 + 2*x6 + x7;
      0 = u7 + 3*x6 + 4*x7;
      0 = u8 + x8 - sin(x8);

      annotation (experiment(StopTime=30));
    end SimpleODAE2;
  end ODAEs;

  package Tearing
    model example1
      parameter Real x1d=3;
      parameter Real x6ddd=4;
      Real x1dd, x2dd, x3dd, x4d, x5;
    equation
      0 = x1dd - x2dd;
      0 = x1dd + x2dd - x3dd + x6ddd;
      0 = x1d  + x3dd - x4d;
      0 = 2*x1dd + x2dd + x3dd + x4d + x6ddd;
      0 = 3*x1dd + 2*x2dd + x5;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end example1;
  end Tearing;

  package Examples
    model PendulumWithDamper
      inner Modelica.Mechanics.MultiBody.World world(gravityType=Modelica.Mechanics.MultiBody.Types.GravityTypes.UniformGravity)
                            annotation (Placement(transformation(extent={{-60,0},{
                -40,20}})));
      Modelica.Mechanics.MultiBody.Joints.Revolute rev(
        n={0,0,1},
        useAxisFlange=true,
        phi(fixed=true),
        w(fixed=true))             annotation (Placement(transformation(extent={{
                -20,0},{0,20}})));
      Modelica.Mechanics.Rotational.Components.Damper damper(d=0.2)
        annotation (Placement(transformation(extent={{-20,40},{0,60}})));
      Modelica.Mechanics.MultiBody.Parts.Body body(m=0.5, r_CM={1.6/2,0,0})
        annotation (Placement(transformation(extent={{20,0},{40,20}})));
    equation
      connect(world.frame_b,rev. frame_a)
        annotation (Line(
          points={{-40,10},{-20,10}},
          color={95,95,95},
          thickness=0.5));
      connect(damper.flange_b,rev. axis) annotation (Line(points={{0,50},{4,50},{4,
              26},{-10,26},{-10,20}}));
      connect(rev.support,damper. flange_a) annotation (Line(points={{-16,20},{-16,
              26},{-28,26},{-28,50},{-20,50}}));
      connect(body.frame_a,rev. frame_b) annotation (Line(
          points={{20,10},{0,10}},
          color={95,95,95},
          thickness=0.5));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=5));
    end PendulumWithDamper;
  end Examples;
  annotation (uses(Modelica(version="3.2.2")));
end ModelicaReferenceModels;
