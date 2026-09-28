import type { SVGProps } from "react";

function Icon({ children, ...props }: SVGProps<SVGSVGElement>) {
  return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...props}>{children}</svg>;
}

export const ArrowLeft = (props: SVGProps<SVGSVGElement>) => <Icon {...props}><path d="M19 12H5M11 18l-6-6 6-6" /></Icon>;
export const Compass = (props: SVGProps<SVGSVGElement>) => <Icon {...props}><circle cx="12" cy="12" r="9" /><path d="m15 9-2 4-4 2 2-4 4-2Z" /></Icon>;
export const Book = (props: SVGProps<SVGSVGElement>) => <Icon {...props}><path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H11v17H6.5A2.5 2.5 0 0 0 4 22V5.5ZM20 5.5A2.5 2.5 0 0 0 17.5 3H13v17h4.5A2.5 2.5 0 0 1 20 22V5.5Z" /></Icon>;
export const Users = (props: SVGProps<SVGSVGElement>) => <Icon {...props}><path d="M16 20v-1.5A3.5 3.5 0 0 0 12.5 15h-5A3.5 3.5 0 0 0 4 18.5V20M10 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM18 8a3 3 0 0 1 0 6M20 20v-1.5a3.5 3.5 0 0 0-2-3.15" /></Icon>;
export const Calendar = (props: SVGProps<SVGSVGElement>) => <Icon {...props}><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M16 3v4M8 3v4M3 10h18M8 14h.01M12 14h.01M16 14h.01M8 17.5h.01M12 17.5h.01" /></Icon>;
export const Check = (props: SVGProps<SVGSVGElement>) => <Icon {...props}><path d="m5 12 4 4L19 6" /></Icon>;
export const Menu = (props: SVGProps<SVGSVGElement>) => <Icon {...props}><path d="M4 7h16M4 12h16M4 17h16" /></Icon>;
