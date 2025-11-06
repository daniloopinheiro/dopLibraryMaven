package com.biblioteca.service;

import com.biblioteca.dto.AutorDTO;
import com.biblioteca.dto.BatchResultDTO;
import com.biblioteca.exception.ResourceNotFoundException;
import com.biblioteca.model.Autor;
import com.biblioteca.repository.AutorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AutorService {

    @Autowired
    private AutorRepository autorRepository;

    @Transactional(readOnly = true)
    public List<AutorDTO> findAll() {
        return autorRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public AutorDTO findById(Integer id) {
        Autor autor = autorRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Autor não encontrado com id: " + id));
        return convertToDTO(autor);
    }

    @Transactional(readOnly = true)
    public List<AutorDTO> searchByName(String name) {
        return autorRepository.findByNomeContainingIgnoreCaseOrSobrenomeContainingIgnoreCase(name, name)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<AutorDTO> findByNacionalidade(String nacionalidade) {
        return autorRepository.findByNacionalidade(nacionalidade).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public AutorDTO create(AutorDTO autorDTO) {
        Autor autor = convertToEntity(autorDTO);
        Autor savedAutor = autorRepository.save(autor);
        return convertToDTO(savedAutor);
    }

    @Transactional
    public List<AutorDTO> createBatch(List<AutorDTO> autoresDTO) {
        List<Autor> resultadoAutores = autoresDTO.stream()
                .map(dto -> {
                    // Verifica se autor já existe
                    return autorRepository.findByNomeAndSobrenome(dto.getNome(), dto.getSobrenome())
                            .orElseGet(() -> {
                                // Se não existe, cria novo
                                Autor novoAutor = convertToEntity(dto);
                                return autorRepository.save(novoAutor);
                            });
                })
                .collect(Collectors.toList());
        
        return resultadoAutores.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public BatchResultDTO createBatchWithResult(List<AutorDTO> autoresDTO) {
        List<Autor> resultadoAutores = new ArrayList<>();
        int criados = 0;
        int existentes = 0;
        
        for (AutorDTO dto : autoresDTO) {
            var autorExistente = autorRepository.findByNomeAndSobrenome(dto.getNome(), dto.getSobrenome());
            
            if (autorExistente.isPresent()) {
                // Autor já existe
                resultadoAutores.add(autorExistente.get());
                existentes++;
            } else {
                // Criar novo autor
                Autor novoAutor = convertToEntity(dto);
                Autor savedAutor = autorRepository.save(novoAutor);
                resultadoAutores.add(savedAutor);
                criados++;
            }
        }
        
        List<AutorDTO> autoresRetorno = resultadoAutores.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        return new BatchResultDTO(autoresRetorno, criados, existentes);
    }

    @Transactional
    public AutorDTO update(Integer id, AutorDTO autorDTO) {
        Autor autor = autorRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Autor não encontrado com id: " + id));

        autor.setNome(autorDTO.getNome());
        autor.setSobrenome(autorDTO.getSobrenome());
        autor.setNacionalidade(autorDTO.getNacionalidade());
        autor.setDataNascimento(autorDTO.getDataNascimento());
        autor.setBiografia(autorDTO.getBiografia());

        Autor updatedAutor = autorRepository.save(autor);
        return convertToDTO(updatedAutor);
    }

    @Transactional
    public void delete(Integer id) {
        if (!autorRepository.existsById(id)) {
            throw new ResourceNotFoundException("Autor não encontrado com id: " + id);
        }
        autorRepository.deleteById(id);
    }

    private AutorDTO convertToDTO(Autor autor) {
        AutorDTO dto = new AutorDTO();
        dto.setIdAutor(autor.getIdAutor());
        dto.setNome(autor.getNome());
        dto.setSobrenome(autor.getSobrenome());
        dto.setNacionalidade(autor.getNacionalidade());
        dto.setDataNascimento(autor.getDataNascimento());
        dto.setBiografia(autor.getBiografia());
        dto.setDataCadastro(autor.getDataCadastro());
        return dto;
    }

    private Autor convertToEntity(AutorDTO dto) {
        Autor autor = new Autor();
        autor.setIdAutor(dto.getIdAutor());
        autor.setNome(dto.getNome());
        autor.setSobrenome(dto.getSobrenome());
        autor.setNacionalidade(dto.getNacionalidade());
        autor.setDataNascimento(dto.getDataNascimento());
        autor.setBiografia(dto.getBiografia());
        return autor;
    }
}

