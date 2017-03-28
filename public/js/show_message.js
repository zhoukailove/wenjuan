$('.save_fen').on('click',function(){
    var fen;
    var total_fen = 0;
    var i;
    $('.form-control').each(function(){
        fen = ($(this).val());
        i = $(this).data('id');
        if(fen){
            $('.text-center_'+i).text(fen);
            total_fen += Number(fen);
        }else{
            $('.text-center_'+i).text(0);
        }
    });
    $('.fen>span').text(total_fen);


});