"use client";
import {useEffect,useRef,useState} from "react";
import {createClient} from "@/lib/supabase/client";
/** Shared socket; one opaque topic per open chat. No text, names or presence on Broadcast. */
export function useSupportLive(topic:string|null,refresh:()=>void){
 const callback=useRef(refresh);callback.current=refresh;
 const [status,setStatus]=useState("connecting");
 useEffect(()=>{
  let gone=false,cleanup:(()=>void)|undefined,joinTimer:ReturnType<typeof setTimeout>,debounce:ReturnType<typeof setTimeout>,reconcile:ReturnType<typeof setTimeout>;
  let connected=false;
  function changed(){clearTimeout(debounce);debounce=setTimeout(()=>{if(!gone)callback.current();},180);}
  function schedule(){clearTimeout(reconcile);reconcile=setTimeout(()=>{if(!gone&&!document.hidden){callback.current();}if(!gone)schedule();},connected?60000:30000);}
  function disconnect(){cleanup?.();cleanup=undefined;connected=false;clearTimeout(joinTimer);}
  function join(){
   disconnect();if(gone||document.hidden)return;
   if(!topic){setStatus('idle');schedule();return;}
   setStatus('connecting');
   // Spread visibility/reconnect bursts rather than exceeding join-per-second quotas.
   joinTimer=setTimeout(()=>{
    if(gone||document.hidden)return;
    try{
     const client=createClient();
     const channel=client.channel(topic!,{config:{broadcast:{self:false}}}).on('broadcast',{event:'changed'},changed).subscribe(state=>{
      if(gone)return;
      connected=state==='SUBSCRIBED';setStatus(connected?'connected':'reconnecting');
      if(connected)changed();schedule();
     });
     cleanup=()=>{void client.removeChannel(channel).catch(()=>undefined).finally(()=>{if(client.getChannels().length===0)void client.realtime.disconnect();});};
    }catch{setStatus('reconnecting');schedule();}
   },Math.random()*3000);
  }
  function visibility(){if(document.hidden){disconnect();clearTimeout(reconcile);setStatus('paused');}else{callback.current();join();}}
  join();schedule();document.addEventListener('visibilitychange',visibility);
  return()=>{gone=true;disconnect();clearTimeout(debounce);clearTimeout(reconcile);document.removeEventListener('visibilitychange',visibility);};
 },[topic]);
 return status;
}
