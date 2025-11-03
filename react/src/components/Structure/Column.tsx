import type { CSSProperties, FC, ReactNode, Ref } from 'react';

type Props = {
  ref?: Ref<HTMLDivElement>;
  id?: string;
  className?: string;
  style?: CSSProperties;
  children?: ReactNode;
  onClick?: () => void;
};

const Column: FC<Props> = ({ ref, id, className, style, children, onClick }) => {
  return (
    <div
      ref={ref}
      id={id}
      className={className}
      onClick={onClick}
      style={{
        display: 'flex',
        flexDirection: 'column',
        cursor: onClick ? 'pointer' : undefined,
        ...style,
      }}
    >
      {children}
    </div>
  );
};

export default Column;
