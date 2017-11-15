function varargout = covMN(varargin)

varargout = cell(max(1, nargout), 1);
[varargout{:}] = covScale({'covMNU'}, varargin{:});