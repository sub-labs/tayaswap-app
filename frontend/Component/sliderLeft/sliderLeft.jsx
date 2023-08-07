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
    HStack
  } from '@chakra-ui/react'

import Link from 'next/link'


  import {BiMenuAltLeft} from "react-icons/bi"
  

  const transtionStyleProperty = {
    transition : "all 1s"
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
    <DrawerCloseButton />
      <DrawerHeader>
       Taya Swap
      </DrawerHeader>
      <DrawerBody>
        <VStack alignItems={'flex-start'}>
          <Button   onClick={onClose} colorScheme={'purple'} variant={"ghost"}  style={{textDecoration:'underline' , transitionDelay: '1s'}} >
            <Link href="/">Home</Link>
          </Button>
          <Button  onClick={onClose} colorScheme={'purple'} variant={"ghost"} style={{textDecoration:'underline' , transitionDelay:' 1s'}}  >
            <Link href="/video">Video</Link>
          </Button>
          <Button  onClick={onClose} colorScheme={'purple'} variant={"ghost"}  style={{textDecoration:'underline' , transitionDelay:' 1s'}} >
            <Link href="/video?category=free">Free Video </Link>
          </Button>
          <Button  onClick={onClose} colorScheme={'purple'} variant={"ghost"}  style={{textDecoration:'underline' , transitionDelay:' 1s'}} >
            <Link href="/upload">Upload Video</Link>
          </Button>

        </VStack>

        <HStack pos={'absolute'} bottom={'10'} left={'0'}  w={'full'} justifyContent={'space-evenly'}>

          <Button colorScheme='purple'>
            <Link href={'/login'} >Login</Link>
          </Button>

          
          <Button colorScheme='purple' variant={'outline'}>
            <Link href={'/signup'} >SignUp</Link>
          </Button>
        </HStack>
      </DrawerBody>
      </DrawerContent> 
        </Drawer>
   </>
  )
}

export default SliderLeft