import situacaoAtualRepository from "./situacaoAtualRepository";
//import GitHubRepository from "./gitHubRepository";

const repositories = {
  posts: situacaoAtualRepository,
  //gitHub: GitHubRepository
  // other repositories ...
};

export const RepositoryFactory = {
  get: name => repositories[name]
};
