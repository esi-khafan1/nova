import { AuthorContentEditor } from "@/components/content/author-content-editor";
export default async function Page({params}:{params:Promise<{id:string}>}) {
 const {id}=await params;
 return <AuthorContentEditor kind="podcasts" id={id}/>;
}
