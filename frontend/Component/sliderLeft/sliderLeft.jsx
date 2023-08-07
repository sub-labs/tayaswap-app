"use client"
import React from 'react'
import {
    Drawer,
    DrawerBody,
    DrawerFooter,
    DrawerHeader,
    DrawerOverlay,
    DrawerContent,
    DrawerCloseButton,
    Button,
    useDisclosure,
    VStack,
   Text,
    HStack,
    Container
  } from '@chakra-ui/react'

import Link from 'next/link'
import Image from 'next/image'

import icon  from "../../public/Group 78.svg"


  import {BiMenuAltLeft , BiSolidDashboard , BiLogoLinkedin} from "react-icons/bi"
  import {MdSwapHorizontalCircle} from "react-icons/md"
  import {GiWhirlpoolShuriken , GiStoneBridge} from 'react-icons/gi'
 import {BsBlockquoteLeft ,BsTwitter , BsDiscord, BsLinkedin } from "react-icons/bs"
  import  {AiOutlineLock} from "react-icons/ai"

  const transtionStyleProperty = {
    transition : "all 1.4s"
  }

function SliderLeft() {

    const { isOpen, onOpen, onClose } = useDisclosure()
    const btnRef = React.useRef()
  return (
   <>
   <Button pos={'fixed'} left={'5'} top={'2'} color={"#fff"} style={{backgroundColor:"#1C1C1C"}} py={'1'} px={'1'} w={'14'} h={'12'} borderRadius={'2xl'} zIndex={'20'} onClick={onOpen
  }> 
    <BiMenuAltLeft size={"20"} />
   </Button>

   <Drawer isOpen={isOpen} placement='left'     onClose={onClose}>
    <DrawerOverlay />
    <DrawerContent>
    {/* <DrawerCloseButton /> */}
      <DrawerHeader style={{fontWeight:"700", fontSize:'1.6rem' , color:"#1C1C1C"}}>

      <Image
      priority
      style={{display:'inline' , margin:'0.2rem 1rem 0 0 ' , height:'2rem'}}
      src={icon}
      alt="Follow us on Twitter"
    />


       Taya Swap  
      </DrawerHeader>
      <DrawerBody>
        <VStack alignItems={'flex-start'}>
          <Button   onClick={onClose} color={"#1C1C1C"}  variant={"ghost"}  style={{  transitionDelay: '1s' , fontWeight:'600' }} >
           <BiSolidDashboard style={{marginRight:'1rem'}} />  <Link href="/dashboard">Dashboard</Link>
          </Button>
          <Button  onClick={onClose} color={"#1C1C1C"}  variant={"ghost"} style={{  transitionDelay:' 1s' , fontWeight:'600' }}  >
            <MdSwapHorizontalCircle style={{marginRight:'1rem'}} /> <Link href="/swap">Swap</Link>
          </Button>
          <Button  onClick={onClose} color={"#1C1C1C"}  variant={"ghost"}  style={{  transitionDelay:' 1s' , fontWeight:'600' }} >
           <GiWhirlpoolShuriken style={{marginRight:'1rem'}} />  <Link href="/pools">Pools </Link>
          </Button>
          <Button  onClick={onClose} color={"#1C1C1C"}  variant={"ghost"}  style={{  transitionDelay:' 1s' , fontWeight:'600' }} >
            <AiOutlineLock style={{marginRight:'1rem'}} /> <Link href="/upload">Lockdrop</Link>
          </Button>

          <Button  onClick={onClose} color={"#1C1C1C"}  variant={"ghost"}  style={{  transitionDelay:' 1s' , fontWeight:'600' }} >
           <GiStoneBridge style={{marginRight:'1rem'}} />  <Link href="/upload">Bridge</Link>
          </Button>

          <Button  onClick={onClose} color={"#1C1C1C"}  variant={"ghost"}  style={{  transitionDelay:' 1s' , fontWeight:'600' }} >
           <BsBlockquoteLeft style={{marginRight:'1rem'}} />  <Link href="/upload">Lattery</Link>
          </Button>


        </VStack>

{/* footer of slider  */}
    <Container  pos={'absolute'} bottom={'71'} left={'0'} margin={'0 0 1rem 0'} w={'full'}   display="flex"
      alignItems="center"
      justifyContent="center" >
    <Text style={{fontWeight:'700' , color:'#959595'}} >SubLabs | Pechshield</Text>
    </Container>
   
        <HStack pos={'absolute'} bottom={'10'} left={'0'}  w={'full'} justifyContent={'space-around'} p={'0 1rem'} >

       
     <Link href={'/login'}  > <BsLinkedin size={30} style={{color:'#1C1C1C'}} /></Link>

     <Link href={'/signup'} > <BsTwitter  size={30}  style={{color:'#1C1C1C'}} /> </Link>

     <Link href={'/signup'} > <BsDiscord   size={30}  style={{color:'#1C1C1C'}} /> </Link>
   
        </HStack>
     
       
      </DrawerBody>
      </DrawerContent> 
        </Drawer>
   </>
  )
}

export default SliderLeft