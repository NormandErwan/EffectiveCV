\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{effectivecv}[2018/07/11 Effective CV]

%% Base class and options

\LoadClassWithOptions{article}

\newif\if@coverletter\@coverletterfalse
\DeclareOption{coverletter}{
  \@coverlettertrue
}

\ProcessOptions\relax

%% Packages and class configuration

% Page configuration
\RequirePackage[margin=5mm, bottom=15mm]{geometry}
\if@coverletter
  \geometry{margin=2cm}
\fi

% Font
\renewcommand{\familydefault}{\sfdefault}
\renewcommand*{\sfdefault}{lmss} % Use Latin Modern Sans Serif

% Deactivate content indent
\RequirePackage{parskip}

% Lists
\RequirePackage{enumitem}
\setlist[itemize]{noitemsep, topsep=0mm, partopsep=0mm, leftmargin=7mm}

% URLs
\RequirePackage[hidelinks]{hyperref}
\urlstyle{same} % URL in sans-serif

% Colors
\RequirePackage[dvipsnames]{xcolor}
\newcommand{\cvcolors}[4]{%
  \colorlet{cvcolorfirst}{#1}%
  \colorlet{cvcolorsecond}{#2}%
  \colorlet{cvcolorthird}{#3}%
}
\cvcolors{RoyalBlue}{black}{darkgray} % Default colors

% Lengths
\newcommand{\setnewlength}[2]{%
  \newlength{#1}%
  \setlength{#1}{#2}%
}
\setnewlength{\cvcontentwidth}{\textwidth}
\setnewlength{\cvmaincolumnlength}{0.73\textwidth}
\setnewlength{\cvsidecolumnlength}{0.24\textwidth}

% Footer
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{} % Clear footer
\renewcommand{\headrulewidth}{0mm}
\renewcommand{\footrulewidth}{0mm}
\fancyhfoffset{0mm}
\newcommand{\cvfooter}[3]{%
  \fancyfoot[L]{\textcolor{cvcolorthird}{#1}}%
  \fancyfoot[C]{\textcolor{cvcolorthird}{#2}}%
  \fancyfoot[R]{\textcolor{cvcolorthird}{#3}}%
}

% Utilities
\RequirePackage{ifthen}
\newcommand{\ifempty}[3]{%
  \ifthenelse{\equal{#1}{}}{#2}{#3}%
}

% Other packages
\RequirePackage{graphicx}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{fontawesome}

%% Class commands

% Header commands

\newcommand{\portrait}[1]{\renewcommand{\@portrait}{#1}}
\newcommand{\@portrait}{}

\newcommand{\address}[1]{\renewcommand{\@address}{#1}}
\newcommand{\@address}{}

\newcommand{\extrainfo}[1]{\renewcommand{\@extrainfo}{#1}}
\newcommand{\@extrainfo}{}

\newcommand{\cvlink}[3]{%
  \ifempty{#1}{%
    \ifempty{#2}{}{#2~}#3%
  }{%
    \href{#1}{\ifempty{#2}{}{#2~}#3}%
  }%
}

\newcommand{\email}[1]{\cvlink{mailto:#1}{\faEnvelopeO}{#1}}
\newcommand{\github}[1]{\cvlink{https://github.com/#1}{\faGithub}{#1}}
\newcommand{\linkedin}[1]{\cvlink{https://linkedin.com/in/#1}{\faLinkedin}{#1}}
\newcommand{\phone}[1]{\cvlink{}{\faPhone}{#1}}
\newcommand{\twitter}[1]{\cvlink{https://twitter.com/#1}{\faTwitter}{#1}}

\newcommand{\@cvheadercontent}{%
  \multirow{3}{*}[0.75em]{\ifempty{\@portrait}{}{\includegraphics[height=6em]{\@portrait}}} & \textbf{\huge\@author} \\[1mm]
  & \textcolor{cvcolorfirst}{\Large\@title} \\
  & \textcolor{cvcolorthird}{\small\@address} \\
  & \textcolor{cvcolorthird}{\small\@extrainfo}
}

\newcommand{\cvheader}{%
  \begin{minipage}[t]{\cvcontentwidth}%
    \ifempty{\@portrait}{%
      \begin{tabularx}{\cvcontentwidth}{@{}l@{}X@{}}%
        \@cvheadercontent
      \end{tabularx}%
    }{%
      \begin{tabularx}{\cvcontentwidth}{@{}l X@{}}%
        \@cvheadercontent
      \end{tabularx}%
    }%
  \end{minipage}%
  \par\smallskip%
}

% CV commands
\newcommand{\cvcontent}[3][onecolumn]{%
  \ifthenelse{\equal{#1}{leftsidecolumn}}{%
    \begin{minipage}[t]{\cvsidecolumnlength}#2\end{minipage}%
    \hfill
    \begin{minipage}[t]{\cvmaincolumnlength}#3\end{minipage}%
  }{%
    \ifthenelse{\equal{#1}{rightsidecolumn}}{%
      \begin{minipage}[t]{\cvmaincolumnlength}#2\end{minipage}%
      \hfill
      \begin{minipage}[t]{\cvsidecolumnlength}#3\end{minipage}%
    }{% Default is onecolumn
      \begin{minipage}[t]{\cvcontentwidth}#2\end{minipage}%
    }%
  }%
}

\renewcommand{\section}[1]{%
  \par\smallskip%
  \textcolor{cvcolorfirst}{\textbf{\large #1}}%
  \par\vspace*{-0.7\baselineskip}%
  \textcolor{cvcolorfirst}{\rule{\textwidth}{0.2mm}}%
  \par%
}

\newcommand{\cvitem}[2]{%
  \ifempty{#1}{}{\textcolor{cvcolorsecond}{\textbf{#1}}\\}%
  #2%
  \par\medskip%
}

\newcommand{\cventry}[5]{%
  \par\smallskip%
  \begin{tabularx}{\textwidth}{@{}l@{\extracolsep{\fill}}r@{}}%
    \textcolor{cvcolorsecond}{\textbf{#1}} & \textcolor{cvcolorsecond}{\small #4} \\
    \textcolor{cvcolorthird}{\small #2} & \textcolor{cvcolorthird}{\small #3}
  \end{tabularx}%
  \par\addvspace{0.5mm}%
  #5%
  \par\medskip%
}

% Cover letter commands
\newcommand{\lettersection}[2][L]{%
  \par\bigskip%
  \ifthenelse{\equal{#1}{R}}{%
    \begin{flushright}#2\end{flushright}
  }{%
    \begin{flushleft}#2\end{flushleft}
  }
  \par\bigskip%
}

\newcommand{\letterclosing}{%
  \lettersection[L]{\textbf{\@author}}%
}

\endinput