function [cv_values] = set_cv_values(acc_high_number,dec_high_number,acc_number,neutral_percentage,vavg)
%CV Werte zur Interpolation
%cv.acc_high_number=[max min] Wert
cv_values.acc_high_number=[max(acc_high_number) min(acc_high_number)];
%cv.dec_high_number=[max min] Wert
cv_values.dec_high_number=[max(dec_high_number) min(dec_high_number)];

cv_values.acc_number=[max(acc_number) min(acc_number)];

%cv_values.accpos_mean=[max(accpos_mean) min(accpos_mean)];

%cv_values.accneg_mean=[max(accneg_mean) min(accneg_mean)];

cv_values.vavg=[max(vavg) min(vavg)];

cv_values.neutral_percentage=[min(neutral_percentage) max(neutral_percentage)];

end

