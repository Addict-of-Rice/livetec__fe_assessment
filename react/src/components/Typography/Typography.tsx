import type { CSSProperties, FC, ReactNode, ElementType, Ref } from 'react';
import { useThemeContext } from '../../providers/ThemeProvider';
import type { Theme } from '../../themes/theme';

type Variant = 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6' | 'p' | 'small' | 'tiny';
type Color = 'text' | 'background1' | 'background2' | 'primary' | 'secondary' | 'accent';

type Props = {
  ref?: Ref<HTMLElement>;
  className?: string;
  children: ReactNode;
  variant?: Variant;
  color?: Color | string;
  style?: CSSProperties;
  onClick?: () => void;
  span?: boolean;
  responsiveMin?: Variant;
};

const Typography: FC<Props> = ({
  ref,
  className,
  children,
  variant = 'p',
  color,
  style,
  onClick,
  span,
  responsiveMin,
}) => {
  const variantMap: Record<
    Variant,
    {
      tag: ElementType;
      fontFamilyKey: keyof Theme['fontFamily'];
    }
  > = {
    h1: { tag: 'h1', fontFamilyKey: 'heading' },
    h2: { tag: 'h2', fontFamilyKey: 'heading' },
    h3: { tag: 'h3', fontFamilyKey: 'heading' },
    h4: { tag: 'h4', fontFamilyKey: 'heading' },
    h5: { tag: 'h5', fontFamilyKey: 'heading' },
    h6: { tag: 'h6', fontFamilyKey: 'heading' },
    p: { tag: 'p', fontFamilyKey: 'body' },
    small: { tag: 'p', fontFamilyKey: 'body' },
    tiny: { tag: 'p', fontFamilyKey: 'body' },
  };

  const { theme } = useThemeContext();
  const { tag, fontFamilyKey } = variantMap[variant];
  const Tag = span ? 'span' : tag;

  const fontSize = theme.fontSize[variant];

  return (
    <Tag
      ref={ref}
      className={className}
      style={{
        fontFamily: theme.fontFamily[fontFamilyKey],
        fontSize: responsiveMin
          ? `clamp(${theme.fontSize[responsiveMin]}, 4vw, ${fontSize})`
          : fontSize,
        fontWeight: theme.fontWeight,
        color: color,
        margin: 0,
        padding: 0,
        whiteSpace: 'pre',
        cursor: onClick ? 'pointer' : undefined,
        userSelect: 'none',
        textWrap: 'wrap',
        lineHeight: '16px',
        ...style,
      }}
      onClick={onClick}
    >
      {children}
    </Tag>
  );
};

export const C_h1: FC<Props> = (props) => <Typography variant='h1' {...props} />;
export const C_h2: FC<Props> = (props) => <Typography variant='h2' {...props} />;
export const C_h3: FC<Props> = (props) => <Typography variant='h3' {...props} />;
export const C_h4: FC<Props> = (props) => <Typography variant='h4' {...props} />;
export const C_h5: FC<Props> = (props) => <Typography variant='h5' {...props} />;
export const C_h6: FC<Props> = (props) => <Typography variant='h6' {...props} />;
export const C_p: FC<Props> = (props) => <Typography variant='p' {...props} />;
export const C_s: FC<Props> = (props) => <Typography variant='small' {...props} />;
export const C_t: FC<Props> = (props) => <Typography variant='tiny' {...props} />;

export default Typography;
