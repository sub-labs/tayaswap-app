"use client";
import { ChakraProvider } from '@chakra-ui/react'
import { Spinner } from '@chakra-ui/react'
import SliderLeft from '@/Component/sliderLeft/sliderLeft';

export default function Home() {
  return (
     <ChakraProvider>
      <SliderLeft/>
     </ChakraProvider>
   
  )
}
