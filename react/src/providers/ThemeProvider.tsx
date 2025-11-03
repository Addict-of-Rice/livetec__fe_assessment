import { createContext, useContext, useState } from 'react';
import type { FC, ReactNode } from 'react';
import { defaultTheme } from '../themes/default_theme';
import { compileTheme, type ThemeConfig, type Theme } from '../themes/theme';

type ThemeContextProps = {
  theme: Theme;
  setTheme: (hslTheme: ThemeConfig, darkMode: boolean) => void;
};

const ThemeContext = createContext<ThemeContextProps | undefined>(undefined);

export const useThemeContext = () => {
  const context = useContext(ThemeContext);
  if (!context) throw new Error('useThemeContext must be used within a ThemeProvider');
  return context;
};

type Props = {
  initialTheme?: ThemeConfig;
  darkMode?: boolean;
  children: ReactNode;
};

export const ThemeProvider: FC<Props> = ({
  initialTheme = defaultTheme,
  children,
}) => {
  const [theme, setThemeState] = useState(compileTheme(initialTheme));

  const setTheme = (hslTheme: ThemeConfig) =>
    setThemeState(compileTheme(hslTheme));

  const contextValue: ThemeContextProps = {
    theme,
    setTheme,
  };

  return <ThemeContext.Provider value={contextValue}>{children}</ThemeContext.Provider>;
};

export default ThemeProvider;
