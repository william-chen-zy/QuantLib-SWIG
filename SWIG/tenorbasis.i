
/*
 Copyright (C) 2015 StatPro Italia srl

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it
 under the terms of the QuantLib license.  You should have received a
 copy of the license along with this program; if not, please email
 <quantlib-dev@lists.sf.net>. The license is also available online at
 <http://quantlib.org/license.shtml>.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

#ifndef quantlib_tenor_basis_i
#define quantlib_tenor_basis_i

%include indexes.i
%include optimizers.i
%include forwardratecurve.i

%{
using QuantLib::TenorBasis;
%}

%ignore TenorBasis;
class TenorBasis {
  public:
    Spread value(Date d) const;
    Spread value(Time t) const;

    Rate tenorForwardRate(Date d) const;
    Rate tenorForwardRate(Time t) const;

    Rate forwardRate(Date d) const;
    Rate forwardRate(Date d1,
                     Date d2) const;
    Rate forwardRate(Time t1,
                     Time t2) const;

    const std::vector<Real>& coefficients() const;
    const std::vector<Real>& instCoefficients() const;

    void calibrate(
            const std::vector<boost::shared_ptr<RateHelper> >&,
            OptimizationMethod& method,
            const EndCriteria& endCriteria 
                             = EndCriteria(1000, 100, 1.0e-8, 0.3e-4, 0.3e-4),
            const std::vector<Real>& weights = std::vector<Real>(),
            const std::vector<bool>& fixParameters = std::vector<bool>());
    void forwardCalibrate(
            const std::vector<boost::shared_ptr<ForwardHelper> >&,
            OptimizationMethod& method,
            const EndCriteria& endCriteria 
                             = EndCriteria(1000, 100, 1.0e-8, 0.3e-4, 0.3e-4),
            const std::vector<Real>& weights = std::vector<Real>(),
            const std::vector<bool>& fixParameters = std::vector<bool>());
};
%template(TenorBasis) boost::shared_ptr<TenorBasis>;

%{
using QuantLib::AbcdTenorBasis;
typedef boost::shared_ptr<TenorBasis> AbcdTenorBasisPtr;
%}

%rename(AbcdTenorBasis) AbcdTenorBasisPtr;
class AbcdTenorBasisPtr : public boost::shared_ptr<TenorBasis> {
  public:
    %extend {
      AbcdTenorBasisPtr(IborIndexPtr index,
                        IborIndexPtr baseIndex,
                        Date referenceDate,
                        bool isSimple,
                        const std::vector<Real>& coefficients) {
          boost::shared_ptr<IborIndex> libor =
              boost::dynamic_pointer_cast<IborIndex>(index);
          boost::shared_ptr<IborIndex> base =
              boost::dynamic_pointer_cast<IborIndex>(baseIndex);
          return new AbcdTenorBasisPtr(
                           new AbcdTenorBasis(libor, base, referenceDate,
                                              isSimple, coefficients));
      }
    }
};


%{
using QuantLib::PolynomialTenorBasis;
typedef boost::shared_ptr<TenorBasis> PolynomialTenorBasisPtr;
%}

%rename(PolynomialTenorBasis) PolynomialTenorBasisPtr;
class PolynomialTenorBasisPtr : public boost::shared_ptr<TenorBasis> {
  public:
    %extend {
      PolynomialTenorBasisPtr(IborIndexPtr index,
                              IborIndexPtr baseIndex,
                              Date referenceDate,
                              bool isSimple,
                              const std::vector<Real>& coefficients) {
          boost::shared_ptr<IborIndex> libor =
              boost::dynamic_pointer_cast<IborIndex>(index);
          boost::shared_ptr<IborIndex> base =
              boost::dynamic_pointer_cast<IborIndex>(baseIndex);
          return new PolynomialTenorBasisPtr(
                           new PolynomialTenorBasis(libor, base, referenceDate,
                                                    isSimple, coefficients));
      }
    }
};


%{
using QuantLib::TenorBasisYieldTermStructure;
typedef boost::shared_ptr<YieldTermStructure> TenorBasisYieldTermStructurePtr;
%}

%rename(TenorBasisYieldTermStructure) TenorBasisYieldTermStructurePtr;
class TenorBasisYieldTermStructurePtr : public boost::shared_ptr<YieldTermStructure> {
  public:
    %extend {
        TenorBasisYieldTermStructurePtr(boost::shared_ptr<TenorBasis> basis) {
            return new TenorBasisYieldTermStructurePtr(
                                     new TenorBasisYieldTermStructure(basis));
        }
    }
};


%{
using QuantLib::DiscountCorrectedTermStructure;
typedef boost::shared_ptr<YieldTermStructure> DiscountCorrectedTermStructurePtr;
%}

%rename(DiscountCorrectedTermStructure) DiscountCorrectedTermStructurePtr;
class DiscountCorrectedTermStructurePtr : public boost::shared_ptr<YieldTermStructure> {
  public:
    %extend {
        DiscountCorrectedTermStructurePtr(
                const Handle<YieldTermStructure>& bestFitCurve,
                const std::vector<boost::shared_ptr<RateHelper> >& instruments,
                Real accuracy = 1.0e-12) {
            return new DiscountCorrectedTermStructurePtr(
                               new DiscountCorrectedTermStructure(bestFitCurve,
                                                                  instruments,
                                                                  accuracy));
        }
        const std::vector<Date>& dates() {
            return boost::dynamic_pointer_cast<DiscountCorrectedTermStructure>(*self)
                ->dates();
        }
        const std::vector<Time>& data() {
            return boost::dynamic_pointer_cast<DiscountCorrectedTermStructure>(*self)
                ->data();
        }
    }
};

%{
using QuantLib::TenorBasisForwardRateCurve;
typedef boost::shared_ptr<ForwardRateCurve> TenorBasisForwardRateCurvePtr;
%}

%rename(TenorBasisForwardRateCurve) TenorBasisForwardRateCurvePtr;
class TenorBasisForwardRateCurvePtr : public boost::shared_ptr<ForwardRateCurve> {
  public:
    %extend {
        TenorBasisForwardRateCurvePtr(boost::shared_ptr<TenorBasis> basis) {
            return new TenorBasisForwardRateCurvePtr(
                                     new TenorBasisForwardRateCurve(basis));
        }
    }
};

%{
using QuantLib::ForwardCorrectedTermStructure;
typedef boost::shared_ptr<ForwardRateCurve> ForwardCorrectedTermStructurePtr;
%}

%rename(ForwardCorrectedTermStructure) ForwardCorrectedTermStructurePtr;
class ForwardCorrectedTermStructurePtr : public boost::shared_ptr<ForwardRateCurve> {
  public:
    %extend {
        ForwardCorrectedTermStructurePtr(
                const IborIndexPtr& index,
                const Handle<ForwardRateCurve>& bestFitCurve,
                const std::vector<boost::shared_ptr<ForwardHelper> >& instruments,
                Real accuracy = 1.0e-12) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new ForwardCorrectedTermStructurePtr(
                        new ForwardCorrectedTermStructure(libor->familyName(),
                                                          libor->tenor(),
                                                          libor->fixingDays(),
                                                          libor->currency(),
                                                          libor->fixingCalendar(),
                                                          libor->businessDayConvention(),
                                                          libor->endOfMonth(),
                                                          libor->dayCounter(),
                                                          bestFitCurve,
                                                          instruments,
                                                          accuracy));
        }
        const std::vector<Date>& dates() {
            return boost::dynamic_pointer_cast<ForwardCorrectedTermStructure>(*self)
                ->dates();
        }
        const std::vector<Time>& data() {
            return boost::dynamic_pointer_cast<ForwardCorrectedTermStructure>(*self)
                ->data();
        }
    }
};


#endif
