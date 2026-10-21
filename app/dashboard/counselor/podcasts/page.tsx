import { AuthorContentDirectory } from "@/components/content/author-content-directory";
export default async function Page({searchParams}:{searchParams:Promise<{saved?:string}>}) {
 const params=await searchParams;
 return <AuthorContentDirectory kind="podcasts" saved={params.saved}/>;
}
