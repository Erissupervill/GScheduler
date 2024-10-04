document.addEventListener('DOMContentLoaded', function () {
    var cancelModal = document.getElementById('cancelModal');
    var cancelButtons = document.querySelectorAll('button[data-target="#cancelModal"]');

    cancelButtons.forEach(function (button) {
        button.addEventListener('click', function (event) {
            var reservationId = button.getAttribute('data-reservation-id');
            console.log('Reservation ID:', reservationId);

            var cancelReservationIdInput = document.getElementById('cancelReservationId');
            cancelReservationIdInput.value = reservationId;

            cancelModal.classList.add('show');
            cancelModal.style.display = 'block';
            cancelModal.setAttribute('aria-modal', 'true');
            cancelModal.removeAttribute('aria-hidden');
        });
    });

    var closeButton = cancelModal.querySelector('.close');
    closeButton.addEventListener('click', function () {
        cancelModal.classList.remove('show');
        cancelModal.style.display = 'none';
        cancelModal.setAttribute('aria-hidden', 'true');
        cancelModal.removeAttribute('aria-modal');
    });

    var closeFooterButton = cancelModal.querySelector('.btn-secondary');
    closeFooterButton.addEventListener('click', function () {
        cancelModal.classList.remove('show');
        cancelModal.style.display = 'none';
        cancelModal.setAttribute('aria-hidden', 'true');
        cancelModal.removeAttribute('aria-modal');
    });
});


document.addEventListener('DOMContentLoaded', function () {
    $('#viewReservationModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var reservation_id = button.data('reservationid');
        var customer = button.data('customer');
        var location = button.data('location');
        var date = button.data('date');
        var time = button.data('time');
        var guests = button.data('guests');
        var status = button.data('status');
        var comment = button.data('comment');
        var createdAt = button.data('created-at');
        var updatedAt = button.data('updated-at');
        var updatedByFirstName = button.data('updated-by-firstname');  // Updated
        var updatedByLastName = button.data('updated-by-lastname');    // Updated
        console.log("Button Data Attributes:", button.data());
        var modal = $(this);
        modal.find('#modalReservationID').text(reservation_id);
        modal.find('#modalCustomerName').text(customer);
        modal.find('#modalLocation').text(location);
        modal.find('#modalDate').text(date);
        modal.find('#modalTime').text(time);
        modal.find('#modalGuests').text(guests);
        modal.find('#modalStatus').text(status);
        modal.find('#modalStatusComment').text(comment);
        modal.find('#modalCreatedAt').text(createdAt);
        modal.find('#modalUpdatedAt').text(updatedAt);
        modal.find('#modalUpdatedBy').text(updatedByFirstName + ' ' + updatedByLastName);  // Updated
    });
});

document.addEventListener('DOMContentLoaded', function () {
    // Get the modal element
    var rejectModal = document.getElementById('rejectModal');
   
    // Add event listener to buttons that open the modal
    var rejectButtons = document.querySelectorAll('button[data-target="#rejectModal"]');
    rejectButtons.forEach(function (button) {
        button.addEventListener('click', function (event) {
           // Check if the ID is captured correctly
           var reservationId = button.getAttribute('data-reservation-id');

            // Set the value in the hidden input field inside the modal
            var rejectReservationIdInput = document.getElementById('rejectReservationId');
            rejectReservationIdInput.value = reservationId;

            // Open the modal (you can use Bootstrap's modal methods or manually handle it)
            rejectModal.classList.add('show');
            rejectModal.style.display = 'block';
            rejectModal.setAttribute('aria-modal', 'true');
            rejectModal.removeAttribute('aria-hidden');
        });
    });

    // Add event listener to the close button
    var closeButton = rejectModal.querySelector('.close');
    closeButton.addEventListener('click', function () {
        rejectModal.classList.remove('show');
        rejectModal.style.display = 'none';
        rejectModal.setAttribute('aria-hidden', 'true');
        rejectModal.removeAttribute('aria-modal');
    });

    // Add event listener to the close button in the modal footer
    var closeFooterButton = rejectModal.querySelector('.btn-secondary');
    closeFooterButton.addEventListener('click', function () {
        rejectModal.classList.remove('show');
        rejectModal.style.display = 'none';
        rejectModal.setAttribute('aria-hidden', 'true');
        rejectModal.removeAttribute('aria-modal');
    });
});





document.addEventListener('DOMContentLoaded', () => {
    $('#feedbackModal').on('show.bs.modal', event => {
        const button = $(event.relatedTarget); // Button that triggered the modal
        const feedbackId = button.data('feedback-id');
        const feedbackRating = button.data('feedback-rating');
        const feedbackMessage = button.data('feedback-message');

        const modal = $(event.target);
        modal.find('form').attr('action', `/Admin/Feedbacks/${feedbackId}`);
        modal.find('#feedbackId').val(feedbackId);
        modal.find('#message').val(feedbackMessage);

        // Uncheck all radio buttons first
        modal.find('input[name="rating"]').prop('checked', false);

        // Check the radio button that matches the feedback rating
        const defaultRadio = modal.find(`input[name="rating"][value="${feedbackRating}"]`);
        if (defaultRadio.length) {
            defaultRadio.prop('checked', true);
        } else {
            console.warn(`Radio button with value ${feedbackRating} not found.`);
        }
    });
});

