% res = msvstB3Denoise (data, ctrlval, NSCALE, FSCALE, mu, sigma, alpha, FDR, NITER, DETPOS, KILLLAST)
% For denoise MPG-noise contaminated 1D/2D data using VST+B3 isotropic undecimated wavelet transform.
% MPG noise is modeled as 
%
%          Observation = alpha * Poisson(lambda) + Gaussian(mu, sigma^2) 
%
% The VST used cancels the 1st order residual term of the variance of the
% transformed data.
%
% data      : 1D signal or 2D image to denoise
% ctrlval   : the two-sided p-value if FDR = 0, or the false discovery rate if FDR = 1
% NSCALE    : number of scales used (range: [1, 7])
% FSCALE    : coefficients at any scale smaller than FSCALE are treated insignificant (range: [1, nScale])
% mu, sigma : the mean and the std of Gaussian component of the MPG noise
% alpha     : the gain on the Poisson component in the MPG noise
% FDR       : use FDR-based denoising threshold (0 or 1)
% NITER     : number of iterations (> 1)
% DETPOS    : detect only positive coefficients if set to 1 (for bright-spot detection purpose, not for denoising)
% KILLLAST  : set the coarsest approximation band to 0 if set to 1 (for bright-spot detection purpose, not for denoising)
%
% Note: the program can be used for Poisson noisy data by setting 
% mu = sigma = 0, and gain = 1
%
% Example of usage:
%
% - Setting p-value to 0.01, using 5 scales, processing from 1st scale, and using 10 iterations
%   MPG denoising for alpha = 20, mu = 10, and sigma = 2
% Idenoised = msvstB3Denoise (data, 0.01, 5, 1, 10, 2, 20, 0, 10, 0, 0);
%
%   Pure-Poisson noisy data denoising with the same parameters as above
% Idenoised = msvstB3Denoise (data, 0.01, 5, 1, 0, 0, 1, 0, 10, 0, 0);
%
% - Bright spot detection
% Ires = msvstB3Denoise (data, ctrlval, NSCALE, FSCALE, mu, sigma, alpha, FDR, 0, 0, 1);
% Idetected = (Ires >= some_positive_threshold);
%
%   One can also retain only positive coefficients to supress more artifacts in the detection:
% Ires = msvstB3Denoise (data, ctrlval, NSCALE, FSCALE, mu, sigma, alpha, FDR, 0, 1, 1);
% Idetected = (Ires >= some_positive_threshold);
%
% References: 
% 1. Multiscale variance-stabilizing transform for mixed-Poisson-Gausian
%    processes and its applications in bioimaging
%    B. Zhang, J. M. Fadili, J.-L. Starck, and J.-C. Olivo-Marin, 
%    IEEE International Conference on Image Processing, 2007
%
% 2. Wavelets, Ridgelets and Curvelets for Poisson Noise Removal,
%    B. Zhang, J. M. Fadili, and J.-L. Starck
%    vol. 17, No. 7, pp. 1093-1108, IEEE Transactions on Image Processing, 2008
%
% Author: B. ZHANG (bo.wangzhang@gmail.com)
% Ver.: 2007
function dataEstim = msvstB3Denoise (data, ctrlval, NSCALE, FSCALE, mu, sigma, alpha, FDR, NITER, DETPOS, KILLLAST)
dataEstim = msvstB3Denoisep (data, ctrlval, NSCALE, FSCALE, mu, sigma, alpha, FDR, NITER, DETPOS, KILLLAST);