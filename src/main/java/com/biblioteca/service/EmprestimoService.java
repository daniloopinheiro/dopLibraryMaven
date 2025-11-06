package com.biblioteca.service;

import com.biblioteca.dto.EmprestimoDTO;
import com.biblioteca.exception.BusinessException;
import com.biblioteca.exception.ResourceNotFoundException;
import com.biblioteca.model.Emprestimo;
import com.biblioteca.model.Livro;
import com.biblioteca.model.enums.StatusEmprestimo;
import com.biblioteca.repository.EmprestimoRepository;
import com.biblioteca.repository.LivroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class EmprestimoService {

    @Autowired
    private EmprestimoRepository emprestimoRepository;

    @Autowired
    private LivroRepository livroRepository;

    @Transactional(readOnly = true)
    public List<EmprestimoDTO> findAll() {
        return emprestimoRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public EmprestimoDTO findById(Integer id) {
        Emprestimo emprestimo = emprestimoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Empréstimo não encontrado com id: " + id));
        return convertToDTO(emprestimo);
    }

    @Transactional(readOnly = true)
    public List<EmprestimoDTO> findByStatus(StatusEmprestimo status) {
        return emprestimoRepository.findByStatus(status).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EmprestimoDTO> findByLivro(Integer idLivro) {
        return emprestimoRepository.findByLivroIdLivro(idLivro).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EmprestimoDTO> findByCpfUsuario(String cpf) {
        return emprestimoRepository.findByCpfUsuario(cpf).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EmprestimoDTO> searchByNomeUsuario(String nome) {
        return emprestimoRepository.findByNomeUsuarioContainingIgnoreCase(nome).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EmprestimoDTO> findEmprestimosAtrasados() {
        return emprestimoRepository.findEmprestimosAtrasados(LocalDate.now()).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EmprestimoDTO> findByPeriodo(LocalDate dataInicio, LocalDate dataFim) {
        return emprestimoRepository.findByPeriodo(dataInicio, dataFim).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public EmprestimoDTO create(EmprestimoDTO emprestimoDTO) {
        Livro livro = livroRepository.findById(emprestimoDTO.getIdLivro())
                .orElseThrow(() -> new ResourceNotFoundException("Livro não encontrado com id: " + emprestimoDTO.getIdLivro()));

        // Verify book availability
        if (!livro.getDisponivel() || livro.getQuantidadeEstoque() <= 0) {
            throw new BusinessException("Livro não disponível para empréstimo");
        }

        // Validate dates
        if (emprestimoDTO.getDataPrevistaDevolucao().isBefore(emprestimoDTO.getDataEmprestimo())) {
            throw new BusinessException("Data prevista de devolução não pode ser anterior à data de empréstimo");
        }

        Emprestimo emprestimo = convertToEntity(emprestimoDTO);
        emprestimo.setStatus(StatusEmprestimo.EMPRESTADO);

        // Update book stock
        livro.setQuantidadeEstoque(livro.getQuantidadeEstoque() - 1);
        if (livro.getQuantidadeEstoque() == 0) {
            livro.setDisponivel(false);
        }
        livroRepository.save(livro);

        Emprestimo savedEmprestimo = emprestimoRepository.save(emprestimo);
        return convertToDTO(savedEmprestimo);
    }

    @Transactional
    public EmprestimoDTO devolverLivro(Integer id) {
        Emprestimo emprestimo = emprestimoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Empréstimo não encontrado com id: " + id));

        if (emprestimo.getStatus() == StatusEmprestimo.DEVOLVIDO) {
            throw new BusinessException("Este empréstimo já foi devolvido");
        }

        emprestimo.setDataDevolucao(LocalDate.now());
        emprestimo.setStatus(StatusEmprestimo.DEVOLVIDO);

        // Update book stock
        Livro livro = emprestimo.getLivro();
        livro.setQuantidadeEstoque(livro.getQuantidadeEstoque() + 1);
        livro.setDisponivel(true);
        livroRepository.save(livro);

        Emprestimo updatedEmprestimo = emprestimoRepository.save(emprestimo);
        return convertToDTO(updatedEmprestimo);
    }

    @Transactional
    public EmprestimoDTO update(Integer id, EmprestimoDTO emprestimoDTO) {
        Emprestimo emprestimo = emprestimoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Empréstimo não encontrado com id: " + id));

        emprestimo.setNomeUsuario(emprestimoDTO.getNomeUsuario());
        emprestimo.setCpfUsuario(emprestimoDTO.getCpfUsuario());
        emprestimo.setTelefone(emprestimoDTO.getTelefone());
        emprestimo.setEmail(emprestimoDTO.getEmail());
        emprestimo.setDataPrevistaDevolucao(emprestimoDTO.getDataPrevistaDevolucao());
        emprestimo.setObservacoes(emprestimoDTO.getObservacoes());

        Emprestimo updatedEmprestimo = emprestimoRepository.save(emprestimo);
        return convertToDTO(updatedEmprestimo);
    }

    @Transactional
    public void delete(Integer id) {
        Emprestimo emprestimo = emprestimoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Empréstimo não encontrado com id: " + id));

        // If loan is active, return book to stock
        if (emprestimo.getStatus() == StatusEmprestimo.EMPRESTADO) {
            Livro livro = emprestimo.getLivro();
            livro.setQuantidadeEstoque(livro.getQuantidadeEstoque() + 1);
            livro.setDisponivel(true);
            livroRepository.save(livro);
        }

        emprestimoRepository.deleteById(id);
    }

    @Transactional
    public void atualizarStatusAtrasados() {
        List<Emprestimo> atrasados = emprestimoRepository.findEmprestimosAtrasados(LocalDate.now());
        for (Emprestimo emprestimo : atrasados) {
            emprestimo.setStatus(StatusEmprestimo.ATRASADO);
            emprestimoRepository.save(emprestimo);
        }
    }

    private EmprestimoDTO convertToDTO(Emprestimo emprestimo) {
        EmprestimoDTO dto = new EmprestimoDTO();
        dto.setIdEmprestimo(emprestimo.getIdEmprestimo());
        dto.setIdLivro(emprestimo.getLivro().getIdLivro());
        dto.setTituloLivro(emprestimo.getLivro().getTitulo());
        dto.setNomeUsuario(emprestimo.getNomeUsuario());
        dto.setCpfUsuario(emprestimo.getCpfUsuario());
        dto.setTelefone(emprestimo.getTelefone());
        dto.setEmail(emprestimo.getEmail());
        dto.setDataEmprestimo(emprestimo.getDataEmprestimo());
        dto.setDataPrevistaDevolucao(emprestimo.getDataPrevistaDevolucao());
        dto.setDataDevolucao(emprestimo.getDataDevolucao());
        dto.setStatus(emprestimo.getStatus());
        dto.setObservacoes(emprestimo.getObservacoes());
        return dto;
    }

    private Emprestimo convertToEntity(EmprestimoDTO dto) {
        Livro livro = livroRepository.findById(dto.getIdLivro())
                .orElseThrow(() -> new ResourceNotFoundException("Livro não encontrado com id: " + dto.getIdLivro()));

        Emprestimo emprestimo = new Emprestimo();
        emprestimo.setIdEmprestimo(dto.getIdEmprestimo());
        emprestimo.setLivro(livro);
        emprestimo.setNomeUsuario(dto.getNomeUsuario());
        emprestimo.setCpfUsuario(dto.getCpfUsuario());
        emprestimo.setTelefone(dto.getTelefone());
        emprestimo.setEmail(dto.getEmail());
        emprestimo.setDataEmprestimo(dto.getDataEmprestimo());
        emprestimo.setDataPrevistaDevolucao(dto.getDataPrevistaDevolucao());
        emprestimo.setDataDevolucao(dto.getDataDevolucao());
        emprestimo.setStatus(dto.getStatus());
        emprestimo.setObservacoes(dto.getObservacoes());
        return emprestimo;
    }
}

