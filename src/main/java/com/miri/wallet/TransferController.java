package com.miri.wallet;

import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/transfers")
public class TransferController {
    private final TransferService transferService;

    public TransferController(TransferService transferService) {
        this.transferService = transferService;
    }

    @PostMapping
    public TransferResponse create(
            @RequestHeader("Idempotency-Key") String key,
            @Valid @RequestBody TransferRequest request
    ) {
        var transfer = transferService.transfer(
                key,
                request.fromAccountId(),
                request.toAccountId(),
                request.amount()
        );
        return TransferResponse.from(transfer);
    }
}
