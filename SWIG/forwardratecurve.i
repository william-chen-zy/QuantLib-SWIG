
/*
 Copyright (C) 2016 StatPro Italia srl

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

#ifndef quantlib_forward_rate_curve_i

%include date.i
%include calendars.i
%include daycounters.i
%include marketelements.i
%include types.i
%include vectors.i

%{
using QuantLib::ForwardRateCurve;
%}

%ignore ForwardRateCurve;
class ForwardRateCurve : public Extrapolator {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE)
    %rename("day-counter")     dayCounter;
    %rename("reference-date")  referenceDate;
    %rename("max-date")        maxDate;
    %rename("max-time")        maxTime;
    %rename("forward-rate")    forwardRate;
    #endif
  public:
    DayCounter dayCounter() const;
    Calendar calendar() const;
    Date referenceDate() const;
    Date maxDate() const;
    Time maxTime() const;
    Rate forwardRate(const Date& d,
                     bool extrapolate = false) const;
    Rate forwardRate(Time t,
                     bool extrapolate = false) const;
};

%template(ForwardRateCurve) boost::shared_ptr<ForwardRateCurve>;
IsObservable(boost::shared_ptr<ForwardRateCurve>);

%template(ForwardRateCurveHandle) Handle<ForwardRateCurve>;
IsObservable(Handle<ForwardRateCurve>);
%template(RelinkableForwardRateCurveHandle)
RelinkableHandle<ForwardRateCurve>;


%{
using QuantLib::ForwardIborIndex;
boost::shared_ptr<ForwardIborIndex>
as_forward_index(const boost::shared_ptr<IborIndex>& index,
                 Handle<ForwardRateCurve> curve = Handle<ForwardRateCurve>()) {
    return boost::shared_ptr<ForwardIborIndex>(
        new ForwardIborIndex(index->familyName(),
                             index->tenor(),
                             index->fixingDays(),
                             index->currency(),
                             index->fixingCalendar(),
                             index->businessDayConvention(),
                             index->endOfMonth(),
                             index->dayCounter(),
                             curve));
}
%}

%inline %{
IborIndexPtr forward_index(IborIndexPtr index,
                           Handle<ForwardRateCurve> curve =
                                                 Handle<ForwardRateCurve>()) {
    boost::shared_ptr<IborIndex> libor =
        boost::dynamic_pointer_cast<IborIndex>(index);
    return as_forward_index(libor, curve);
}
%}

%{
using QuantLib::ForwardHelper;
using QuantLib::DepositForwardHelper;
using QuantLib::FraForwardHelper;
using QuantLib::FuturesForwardHelper;
using QuantLib::SwapForwardHelper;
typedef boost::shared_ptr<ForwardHelper> DepositForwardHelperPtr;
typedef boost::shared_ptr<ForwardHelper> FraForwardHelperPtr;
typedef boost::shared_ptr<ForwardHelper> FuturesForwardHelperPtr;
typedef boost::shared_ptr<ForwardHelper> SwapForwardHelperPtr;
%}

%ignore ForwardHelper;
class ForwardHelper {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE)
    %rename("pillar-date") pillarDate;
    #endif
  public:
    Handle<Quote> quote() const;
    Date pillarDate() const;
};

%template(ForwardHelper) boost::shared_ptr<ForwardHelper>;

%rename(DepositForwardHelper) DepositForwardHelperPtr;
class DepositForwardHelperPtr : public boost::shared_ptr<ForwardHelper> {
  public:
    %extend {
        DepositForwardHelperPtr(const Handle<Quote>& rate,
                                const IborIndexPtr& index) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new DepositForwardHelperPtr(
                     new DepositForwardHelper(rate, as_forward_index(libor)));
        }
        DepositForwardHelperPtr(Rate rate,
                                const IborIndexPtr& index) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new DepositForwardHelperPtr(
                     new DepositForwardHelper(rate, as_forward_index(libor)));
        }
    }
};

%rename(FraForwardHelper) FraForwardHelperPtr;
class FraForwardHelperPtr : public boost::shared_ptr<ForwardHelper> {
  public:
    %extend {
        FraForwardHelperPtr(const Handle<Quote>& rate,
                            Natural monthsToStart,
                            const IborIndexPtr& index) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new FraForwardHelperPtr(
                new FraForwardHelper(rate,monthsToStart,
                                     as_forward_index(libor)));
        }
        FraForwardHelperPtr(Rate rate,
                            Natural monthsToStart,
                            const IborIndexPtr& index) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new FraForwardHelperPtr(
                new FraForwardHelper(rate,monthsToStart,
                                     as_forward_index(libor)));
        }
    }
};

%rename(FuturesForwardHelper) FuturesForwardHelperPtr;
class FuturesForwardHelperPtr : public boost::shared_ptr<ForwardHelper> {
  public:
    %extend {
        FuturesForwardHelperPtr(const Handle<Quote>& price,
                                Date startDate,
                                const IborIndexPtr& index,
                                const Handle<Quote>& convexityAdjustment) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new FuturesForwardHelperPtr(
                new FuturesForwardHelper(price,startDate,
                                         as_forward_index(libor),
                                         convexityAdjustment));
        }
        FuturesForwardHelperPtr(Real price,
                                Date startDate,
                                const IborIndexPtr& index,
                                Real convexityAdjustment = 0.0) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new FuturesForwardHelperPtr(
                new FuturesForwardHelper(price,startDate,
                                         as_forward_index(libor),
                                         convexityAdjustment));
        }
    }
};

%rename(SwapForwardHelper) SwapForwardHelperPtr;
class SwapForwardHelperPtr : public boost::shared_ptr<ForwardHelper> {
  public:
    %extend {
        SwapForwardHelperPtr(
                const Handle<Quote>& rate,
                const Period& tenor,
                const Calendar& calendar,
                Frequency fixedFrequency,
                BusinessDayConvention fixedConvention,
                const DayCounter& fixedDayCount,
                const IborIndexPtr& index,
                const Handle<Quote>& spread = Handle<Quote>(),
                const Period& fwdStart = 0*Days,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>()) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new SwapForwardHelperPtr(
                new SwapForwardHelper(rate, tenor, calendar,
                                     fixedFrequency, fixedConvention,
                                     fixedDayCount, as_forward_index(libor),
                                     spread, fwdStart,
                                     discountingCurve));
        }
        SwapForwardHelperPtr(
                Rate rate,
                const Period& tenor,
                const Calendar& calendar,
                Frequency fixedFrequency,
                BusinessDayConvention fixedConvention,
                const DayCounter& fixedDayCount,
                const IborIndexPtr& index,
                const Handle<Quote>& spread = Handle<Quote>(),
                const Period& fwdStart = 0*Days,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>()) {
            boost::shared_ptr<IborIndex> libor =
                boost::dynamic_pointer_cast<IborIndex>(index);
            return new SwapForwardHelperPtr(
                new SwapForwardHelper(rate, tenor, calendar,
                                     fixedFrequency, fixedConvention,
                                     fixedDayCount, as_forward_index(libor),
                                     spread, fwdStart,
                                     discountingCurve));
        }
    }
};


// allow use of ForwardHelper vectors
#if defined(SWIGCSHARP)
SWIG_STD_VECTOR_ENHANCED( boost::shared_ptr<ForwardHelper> )
#endif
namespace std {
    %template(ForwardHelperVector) vector<boost::shared_ptr<ForwardHelper> >;
}


#endif
