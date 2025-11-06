package com.biblioteca.service;

import com.biblioteca.dto.LivroDTO;
import com.biblioteca.exception.BusinessException;
import com.biblioteca.exception.ResourceNotFoundException;
import com.biblioteca.model.Autor;
import com.biblioteca.model.Livro;
import com.biblioteca.repository.AutorRepository;
import com.biblioteca.repository.LivroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class LivroService {

    @Autowired
    private LivroRepository livroRepository;

    @Autowired
    private AutorRepository autorRepository;

    @Transactional(readOnly = true)
    public List<LivroDTO> findAll() {
        return livroRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public LivroDTO findById(Integer id) {
        Livro livro = livroRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Livro não encontrado com id: " + id));
        return convertToDTO(livro);
    }

    @Transactional(readOnly = true)
    public List<LivroDTO> searchByTitulo(String titulo) {
        return livroRepository.findByTituloContainingIgnoreCase(titulo).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public LivroDTO findByIsbn(String isbn) {
        Livro livro = livroRepository.findByIsbn(isbn)
                .orElseThrow(() -> new ResourceNotFoundException("Livro não encontrado com ISBN: " + isbn));
        return convertToDTO(livro);
    }

    @Transactional(readOnly = true)
    public List<LivroDTO> findByAutor(Integer idAutor) {
        return livroRepository.findByAutorIdAutor(idAutor).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<LivroDTO> findByGenero(String genero) {
        return livroRepository.findByGenero(genero).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<LivroDTO> findDisponiveis() {
        return livroRepository.findLivrosDisponiveis().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public LivroDTO create(LivroDTO livroDTO) {
        // Validate ISBN uniqueness
        if (livroDTO.getIsbn() != null && livroRepository.findByIsbn(livroDTO.getIsbn()).isPresent()) {
            throw new BusinessException("Já existe um livro cadastrado com o ISBN: " + livroDTO.getIsbn());
        }

        Livro livro = convertToEntity(livroDTO);
        Livro savedLivro = livroRepository.save(livro);
        return convertToDTO(savedLivro);
    }

    @Transactional
    public LivroDTO update(Integer id, LivroDTO livroDTO) {
        Livro livro = livroRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Livro não encontrado com id: " + id));

        // Validate ISBN uniqueness (excluding current book)
        if (livroDTO.getIsbn() != null) {
            livroRepository.findByIsbn(livroDTO.getIsbn()).ifPresent(existingLivro -> {
                if (!existingLivro.getIdLivro().equals(id)) {
                    throw new BusinessException("Já existe outro livro cadastrado com o ISBN: " + livroDTO.getIsbn());
                }
            });
        }

        Autor autor = autorRepository.findById(livroDTO.getIdAutor())
                .orElseThrow(() -> new ResourceNotFoundException("Autor não encontrado com id: " + livroDTO.getIdAutor()));

        livro.setTitulo(livroDTO.getTitulo());
        livro.setAutor(autor);
        livro.setIsbn(livroDTO.getIsbn());
        livro.setEditora(livroDTO.getEditora());
        livro.setAnoPublicacao(livroDTO.getAnoPublicacao());
        livro.setGenero(livroDTO.getGenero());
        livro.setNumeroPaginas(livroDTO.getNumeroPaginas());
        livro.setQuantidadeEstoque(livroDTO.getQuantidadeEstoque());
        livro.setDisponivel(livroDTO.getDisponivel());

        Livro updatedLivro = livroRepository.save(livro);
        return convertToDTO(updatedLivro);
    }

    @Transactional
    public void delete(Integer id) {
        if (!livroRepository.existsById(id)) {
            throw new ResourceNotFoundException("Livro não encontrado com id: " + id);
        }
        livroRepository.deleteById(id);
    }

    @Transactional
    public void updateDisponibilidade(Integer id, Boolean disponivel) {
        Livro livro = livroRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Livro não encontrado com id: " + id));
        livro.setDisponivel(disponivel);
        livroRepository.save(livro);
    }

    private LivroDTO convertToDTO(Livro livro) {
        LivroDTO dto = new LivroDTO();
        dto.setIdLivro(livro.getIdLivro());
        dto.setTitulo(livro.getTitulo());
        dto.setIdAutor(livro.getAutor().getIdAutor());
        dto.setNomeAutor(livro.getAutor().getNome() + " " + livro.getAutor().getSobrenome());
        dto.setIsbn(livro.getIsbn());
        dto.setEditora(livro.getEditora());
        dto.setAnoPublicacao(livro.getAnoPublicacao());
        dto.setGenero(livro.getGenero());
        dto.setNumeroPaginas(livro.getNumeroPaginas());
        dto.setQuantidadeEstoque(livro.getQuantidadeEstoque());
        dto.setDisponivel(livro.getDisponivel());
        dto.setDataCadastro(livro.getDataCadastro());
        return dto;
    }

    private Livro convertToEntity(LivroDTO dto) {
        Autor autor = autorRepository.findById(dto.getIdAutor())
                .orElseThrow(() -> new ResourceNotFoundException("Autor não encontrado com id: " + dto.getIdAutor()));

        Livro livro = new Livro();
        livro.setIdLivro(dto.getIdLivro());
        livro.setTitulo(dto.getTitulo());
        livro.setAutor(autor);
        livro.setIsbn(dto.getIsbn());
        livro.setEditora(dto.getEditora());
        livro.setAnoPublicacao(dto.getAnoPublicacao());
        livro.setGenero(dto.getGenero());
        livro.setNumeroPaginas(dto.getNumeroPaginas());
        livro.setQuantidadeEstoque(dto.getQuantidadeEstoque());
        livro.setDisponivel(dto.getDisponivel());
        return livro;
    }
}

