import type { CSSProperties, FC, ReactNode, Ref } from 'react';

type Props = {
  ref?: Ref<HTMLDivElement>;
  className?: string;
  style?: CSSProperties;
  children?: ReactNode;
  onClick?: () => void;
};

const Row: FC<Props> = ({ ref, className, style, children, onClick }) => {
  return (
    <div
      ref={ref}
      className={className}
      style={{
        display: 'flex',
        flexDirection: 'row',
        // flexWrap: 'wrap',
        cursor: onClick ? 'pointer' : undefined,
        ...style,
      }}
      onClick={onClick}
    >
      {children}
    </div>
  );
};

export default Row;
