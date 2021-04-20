import { LightningElement } from 'lwc';

export default class CarouselDemo extends LightningElement {
    options = { autoScroll: true, autoScrollTime: 5 };
    items = [
        {
            image: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
            header: 'Landscape 1',
            description: 'Demo image for carousel.',
            href: 'https://www.youtube.com/watch?v=d_Yn5X3T5vo'
        }, {
            video: 'https://www.youtube.com/embed/bRmpRK22bA4',
            header: 'Video 1',
            description: 'Demo video for carousel.',
        },
        {
            image: 'https://i.unu.edu/media/ourworld.unu.edu-en/article/8564/Champions_of_Cumbria_Human_Landscapes1.jpg',
            header: 'Landscape 7',
            description: 'Demo image for carousel.',
        }, {
            image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVGWCqosuufmXUpuQDGpktXc2e1PaIB2K-cOhJBVEFOuP4hjWR&usqp=CAU',
            header: 'Landscape 8',
            description: 'Demo image for carousel.',
        }
    ]
}